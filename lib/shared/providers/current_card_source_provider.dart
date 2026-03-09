import 'package:flutter_riverpod/legacy.dart';
import 'package:solut/shared/consts/card_source.dart';

final currentCardsSourceProvider =
    StateNotifierProvider<CurrentCardsSourceNotifier, CardSource>(
      (ref) => CurrentCardsSourceNotifier(),
    );

class CurrentCardsSourceNotifier extends StateNotifier<CardSource> {
  CurrentCardsSourceNotifier() : super(CardSource.column);

  void setSource(CardSource source) {
    state = source;
  }
}
