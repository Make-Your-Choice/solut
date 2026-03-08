import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final heartsProvider =
    StateNotifierProvider<HeartsNotifier, List<SuitCardDataClass>>(
      (ref) => HeartsNotifier(),
    );

class HeartsNotifier extends StateNotifier<List<SuitCardDataClass>> {
  HeartsNotifier() : super([]);

  void add(SuitCardDataClass card) {
    state = [...state, card];
  }

  void clear() {
    state = [];
  }
}
