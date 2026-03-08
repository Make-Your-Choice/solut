import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final diamondsProvider =
    StateNotifierProvider<DiamondsNotifier, List<SuitCardDataClass>>(
      (ref) => DiamondsNotifier(),
    );

class DiamondsNotifier extends StateNotifier<List<SuitCardDataClass>> {
  DiamondsNotifier() : super([]);

  void add(SuitCardDataClass card) {
    state = [...state, card];
  }

  void clear() {
    state = [];
  }
}
