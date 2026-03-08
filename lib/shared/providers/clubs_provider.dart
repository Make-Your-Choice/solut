import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final clubsProvider =
    StateNotifierProvider<ClubsNotifier, List<SuitCardDataClass>>(
      (ref) => ClubsNotifier(),
    );

class ClubsNotifier extends StateNotifier<List<SuitCardDataClass>> {
  ClubsNotifier() : super([]);

  void add(SuitCardDataClass card) {
    state = [...state, card];
  }

  void clear() {
    state = [];
  }
}
