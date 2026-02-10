import 'package:flutter/cupertino.dart';
import 'package:solut/shared/consts/card_type.dart';

import '../consts/card_number.dart';
import '../theme/app_colors.dart';

class CardUtils {
  static IconData getIcon(SuitType suit) {
    switch (suit) {
      case SuitType.clubs : return CupertinoIcons.suit_club_fill;
      case SuitType.diamonds : return CupertinoIcons.suit_diamond_fill;
      case SuitType.hearts: return CupertinoIcons.suit_heart_fill;
      case SuitType.spades : return CupertinoIcons.suit_spade_fill;
    }
  }

  static Color getColor(SuitType suit) {
    switch (suit) {
      case SuitType.clubs || SuitType.spades : return AppColors.darkCoffee;
      case SuitType.diamonds || SuitType.hearts : return AppColors.scarlettRush;
    }
  }

  static String getTitle(CardNumber number) {
    switch (number) {
      case CardNumber.A || CardNumber.J || CardNumber.Q || CardNumber.K : return number.name;
      default: return number.index.toString();
    }
  }
}