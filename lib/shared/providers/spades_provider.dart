import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final spadesProvider =
    StateNotifierProvider<SpadesNotifier, List<SuitCardDataClass>>(
      (ref) => SpadesNotifier(),
    );

class SpadesNotifier extends StateNotifier<List<SuitCardDataClass>> {
  SpadesNotifier() : super([]);

  void add(SuitCardDataClass card) {
    state = [...state, card];
  }

  void clear() {
    state = [];
  }
}
