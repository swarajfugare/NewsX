import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestsNotifier extends StateNotifier<Set<String>> {
  InterestsNotifier() : super({'AI', 'Technology', 'Cricket'});

  void toggleInterest(String category) {
    if (state.contains(category)) {
      state = {...state}..remove(category);
    } else {
      state = {...state, category};
    }
  }

  bool isSelected(String category) => state.contains(category);

  bool get isValidSelection => state.length >= 3;
}

final interestsProvider = StateNotifierProvider<InterestsNotifier, Set<String>>((ref) {
  return InterestsNotifier();
});
