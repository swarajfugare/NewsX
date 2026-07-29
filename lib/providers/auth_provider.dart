import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class AuthState {
  final User? firebaseUser;
  final String? backendJwt;
  final Map<String, dynamic>? userProfile;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.firebaseUser,
    this.backendJwt,
    this.userProfile,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => firebaseUser != null || (backendJwt != null && backendJwt!.isNotEmpty);

  AuthState copyWith({
    User? firebaseUser,
    String? backendJwt,
    Map<String, dynamic>? userProfile,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      backendJwt: backendJwt ?? this.backendJwt,
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.apiBaseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));

  AuthNotifier() : super(const AuthState()) {
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      debugPrint('🔥 Firebase authStateChanges triggered. User: ${user?.email} (UID: ${user?.uid})');
      if (user != null) {
        final idToken = await user.getIdToken();
        await _syncUserWithBackend(idToken, user.displayName, user.email, user.photoURL);
        state = state.copyWith(firebaseUser: user, isLoading: false);
      } else {
        _restoreGuestOrLocalToken();
      }
    });
  }

  Future<void> _restoreGuestOrLocalToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJwt = prefs.getString('newsx_backend_jwt');
      if (savedJwt != null && savedJwt.isNotEmpty) {
        state = state.copyWith(backendJwt: savedJwt, isLoading: false);
      } else {
        state = const AuthState(isLoading: false);
      }
    } catch (_) {
      state = const AuthState(isLoading: false);
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      debugPrint('🔵 Step 1: Triggering Google Account Picker...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('🟡 Google Sign-In cancelled by user.');
        state = state.copyWith(isLoading: false);
        return false;
      }

      debugPrint('🔵 Step 2: Google user selected: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      debugPrint('🔵 Step 3: Google Auth tokens received. AccessToken present: ${googleAuth.accessToken != null}, IDToken present: ${googleAuth.idToken != null}');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('🔵 Step 4: Signing in to Firebase Authentication with Credential...');
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase authentication returned a null user.');
      }

      debugPrint('🟢 Step 5: Firebase Authentication Successful! UID: ${firebaseUser.uid}, Email: ${firebaseUser.email}');
      final idToken = await firebaseUser.getIdToken();

      await _syncUserWithBackend(idToken, firebaseUser.displayName ?? googleUser.displayName, firebaseUser.email ?? googleUser.email, firebaseUser.photoURL ?? googleUser.photoUrl);
      state = state.copyWith(firebaseUser: firebaseUser, isLoading: false);
      return true;
    } catch (e, stack) {
      debugPrint('🔴 ERROR in signInWithGoogle: $e\n$stack');
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> registerWithEmail(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      final idToken = await userCredential.user?.getIdToken();

      await _syncUserWithBackend(idToken, name, email, null);
      state = state.copyWith(firebaseUser: userCredential.user, isLoading: false);
      return true;
    } catch (e) {
      debugPrint('🔴 Email Registration Error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final idToken = await userCredential.user?.getIdToken();
      await _syncUserWithBackend(idToken, userCredential.user?.displayName, email, null);
      state = state.copyWith(firebaseUser: userCredential.user, isLoading: false);
      return true;
    } catch (e) {
      debugPrint('🔴 Email Login Error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('🔴 Password Reset Error: $e');
    }
  }

  Future<void> _syncUserWithBackend(String? firebaseToken, String? name, String? email, String? photo) async {
    try {
      debugPrint('🔵 Syncing authenticated user ($email) with backend POST /api/v1/auth/login...');
      final response = await _dio.post('/auth/login', data: {
        'firebaseToken': firebaseToken,
        'name': name,
        'email': email,
        'photo': photo,
      });

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        final jwt = data['token'] as String?;
        final profile = data['user'] as Map<String, dynamic>?;

        debugPrint('🟢 Backend User Sync Succeeded! Received JWT token & User Profile: $profile');
        if (jwt != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('newsx_backend_jwt', jwt);
          state = state.copyWith(backendJwt: jwt, userProfile: profile, isLoading: false);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Backend sync warning: $e');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('newsx_backend_jwt');
    } catch (_) {}
    state = const AuthState(isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
