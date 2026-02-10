import 'package:flutter/cupertino.dart';
import 'package:solut/shared/consts/card_type.dart';

import '../theme/app_colors.dart';
import '../utils/card_utils.dart';

class CardCell extends StatelessWidget {
  const CardCell({super.key, required SuitType suit}) : _suit = suit;

  final SuitType _suit;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.teaGreen,
        ),
        height: 90,
        width: 70,
        child: Icon(
          CardUtils.getIcon(_suit),
          color: CardUtils.getColor(_suit),
          size: 40,
        ),
    );
  }

}
