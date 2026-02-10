import 'package:solut/shared/data_calsses/suit_data_class.dart';

import '../consts/card_number.dart';

class SuitCardDataClass {
  final CardNumber number;
  final SuitDataClass suit;
  bool isFaceUp;
  SuitCardDataClass({required this.suit, required this.number, this.isFaceUp = false});

  void setFaceUp(bool isFaceUp) {
    this.isFaceUp = isFaceUp;
  }
}