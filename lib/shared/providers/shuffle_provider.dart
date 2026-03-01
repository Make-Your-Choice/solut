import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final shuffleProvider =
    StateNotifierProvider<ShuffleNotifier, List<SuitCardDataClass>>(
      (ref) => ShuffleNotifier(),
    );

class ShuffleNotifier extends StateNotifier<List<SuitCardDataClass>> {
  ShuffleNotifier() : super([]);

  void addAll(List<SuitCardDataClass> cards) {
    state = [...cards];
  }

  void setAllFaceDown() {
    final currentState = state;
    for (var item in currentState) {
      item.setFaceUp(false);
    }
    state = [...currentState];
  }

  void setFaceUp(int index, {required isFaceUp}) {
    final currentState = state;
    currentState[index].setFaceUp(isFaceUp);
    state = [...currentState];
  }

  void removeAt(int index) {
    final currentState = state;
    currentState.removeAt(index);
    state = [...currentState];
  }
}
