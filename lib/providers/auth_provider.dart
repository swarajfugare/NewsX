import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

enum AuthStatus { loading, authenticated, guest, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? firebaseUser;
  final String? backendJwt;
  final Map<String, dynamic>? userProfile;
  final String? error;

  const AuthState({
    this.status = AuthStatus.loading,
    this.firebaseUser,
    this.backendJwt,
    this.userProfile,
    this.error,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.guest;
  bool get isLoading => status == AuthStatus.loading;

  String get displayName {
    if (isGuest) return 'Guest User';
    return firebaseUser?.displayName ?? userProfile?['name'] as String? ?? 'News Reader';
  }

  String get displayEmail {
    if (isGuest) return 'guest@newsx.app';
    return firebaseUser?.email ?? userProfile?['email'] as String? ?? 'reader@newsx.app';
  }

  String get displayPhoto {
    if (isGuest) return AppConstants.defaultUserAvatar;
    return firebaseUser?.photoURL ?? userProfile?['photo'] as String? ?? AppConstants.defaultUserAvatar;
  }

  AuthState copyWith({
    AuthStatus? status,
    User? firebaseUser,
    String? backendJwt,
    Map<String, dynamic>? userProfile,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      backendJwt: backendJwt ?? this.backendJwt,
      userProfile: userProfile ?? this.userProfile,
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

  AuthNotifier() : super(const AuthState(status: AuthStatus.loading)) {
    checkAndRestoreSession();
  }

  Future<void> checkAndRestoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJwt = prefs.getString('newsx_backend_jwt');
      final sessionMode = prefs.getString('newsx_session_mode');

      if (savedJwt != null && savedJwt.isNotEmpty) {
        final currentUser = _firebaseAuth.currentUser;
        state = AuthState(
          status: AuthStatus.authenticated,
          backendJwt: savedJwt,
          firebaseUser: currentUser,
        );
        return;
      }

      if (sessionMode == 'guest') {
        state = const AuthState(status: AuthStatus.guest);
        return;
      }

      // Listen to Firebase auth state if present
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final idToken = await currentUser.getIdToken();
        await _syncUserWithBackend(idToken, currentUser.displayName, currentUser.email, currentUser.photoURL);
        state = AuthState(
          status: AuthStatus.authenticated,
          firebaseUser: currentUser,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> signInAsGuest() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('newsx_session_mode', 'guest');
      await prefs.remove('newsx_backend_jwt');
    } catch (_) {}
    state = const AuthState(status: AuthStatus.guest);
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase authentication returned a null user.');
      }

      final idToken = await firebaseUser.getIdToken();
      await _syncUserWithBackend(
        idToken,
        firebaseUser.displayName ?? googleUser.displayName,
        firebaseUser.email ?? googleUser.email,
        firebaseUser.photoURL ?? googleUser.photoUrl,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('newsx_session_mode', 'authenticated');

      state = state.copyWith(
        status: AuthStatus.authenticated,
        firebaseUser: firebaseUser,
      );
      return true;
    } catch (e) {
      debugPrint('🔴 Google Sign-In Error: $e');
      state = state.copyWith(status: AuthStatus.unauthenticated, error: e.toString());
      return false;
    }
  }

  Future<bool> registerWithEmail(String email, String password, String name) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      final idToken = await userCredential.user?.getIdToken();

      await _syncUserWithBackend(idToken, name, email, null);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('newsx_session_mode', 'authenticated');

      state = state.copyWith(
        status: AuthStatus.authenticated,
        firebaseUser: userCredential.user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final idToken = await userCredential.user?.getIdToken();
      await _syncUserWithBackend(idToken, userCredential.user?.displayName, email, null);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('newsx_session_mode', 'authenticated');

      state = state.copyWith(
        status: AuthStatus.authenticated,
        firebaseUser: userCredential.user,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, error: e.toString());
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (_) {}
  }

  Future<void> _syncUserWithBackend(String? firebaseToken, String? name, String? email, String? photo) async {
    try {
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

        if (jwt != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('newsx_backend_jwt', jwt);
          state = state.copyWith(backendJwt: jwt, userProfile: profile);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Backend user sync warning: $e');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('newsx_backend_jwt');
      await prefs.remove('newsx_session_mode');
    } catch (_) {}
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
