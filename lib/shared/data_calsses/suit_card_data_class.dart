import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../consts/card_number.dart';
import '../consts/card_type.dart';

class SuitCardDataClass {
  final CardNumber number;
  final SuitType suit;
  bool isFaceUp;
  SuitCardDataClass({required this.suit, required this.number, this.isFaceUp = false});

  void setFaceUp(bool isFaceUp) {
    this.isFaceUp = isFaceUp;
  }
}