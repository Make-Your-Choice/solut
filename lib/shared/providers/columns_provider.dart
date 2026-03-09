import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final columnsProvider =
    StateNotifierProvider<ColumnsNotifier, Map<int, List<SuitCardDataClass>>>(
      (ref) => ColumnsNotifier(),
    );

class ColumnsNotifier extends StateNotifier<Map<int, List<SuitCardDataClass>>> {
  ColumnsNotifier() : super({});

  void addAllToColumn(int columnIndex, List<SuitCardDataClass> cards) {
    final currentState = state;
    currentState[columnIndex] = currentState[columnIndex] == null
        ? [...cards]
        : [...currentState[columnIndex]!, ...cards];
    if (currentState[columnIndex]!.isNotEmpty) {
      currentState[columnIndex]!.last.setFaceUp(true);
    }
    state = {...currentState};
  }

  void addToColumn(int columnIndex, SuitCardDataClass card) {
    final currentState = state;
    currentState[columnIndex] = [...currentState[columnIndex]!, card];
    state = {...currentState};
  }

  void setFaceUp(int columnIndex, int cardIndex, {required isFaceUp}) {
    final currentState = state;

    if (currentState[columnIndex] == null) {
      return;
    }

    if (currentState[columnIndex]!.isEmpty) {
      return;
    }

    if (currentState[columnIndex]!.elementAtOrNull(cardIndex) == null) {
      return;
    }

    currentState[columnIndex]!.elementAt(cardIndex).setFaceUp(isFaceUp);
    state = {...currentState};
  }

  void setLastFaceUp(int columnIndex) {
    final currentState = state;

    if (currentState[columnIndex] == null) {
      return;
    }

    if (currentState[columnIndex]!.isEmpty) {
      return;
    }

    currentState[columnIndex]!.last.setFaceUp(true);
    state = {...currentState};
  }

  void removeFromColumn(int columnIndex, SuitCardDataClass card) {
    final currentState = state;

    if (currentState[columnIndex] == null) {
      return;
    }

    if (!currentState[columnIndex]!.any((item) => item == card)) {
      return;
    }

    final targetIndex = currentState[columnIndex]!.indexOf(card);

    if (targetIndex == 0) {
      currentState[columnIndex] = [];
    } else {
      currentState[columnIndex] = currentState[columnIndex]!.sublist(
        0,
        targetIndex,
      );
    }
    state = {...currentState};
  }

  void removeLastFromColumn(int columnIndex) {
    final currentState = state;

    if (currentState[columnIndex] == null) {
      return;
    }

    if (currentState[columnIndex]!.isEmpty) {
      return;
    }

    if (currentState[columnIndex]!.length == 1) {
      currentState[columnIndex] = [];
    } else {
      currentState[columnIndex] = currentState[columnIndex]!.sublist(
        0,
        currentState[columnIndex]!.length - 1,
      );
    }
    state = {...currentState};
  }

  void clear() {
    state = {};
  }
}
