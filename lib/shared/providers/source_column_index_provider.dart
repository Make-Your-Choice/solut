import 'package:flutter_riverpod/legacy.dart';

final sourceColumnIndexProvider =
    StateNotifierProvider<SourceColumnIndexNotifier, int>(
      (ref) => SourceColumnIndexNotifier(),
    );

class SourceColumnIndexNotifier extends StateNotifier<int> {
  SourceColumnIndexNotifier() : super(-1);

  void setIndex(int index) {
    state = index;
  }
}
