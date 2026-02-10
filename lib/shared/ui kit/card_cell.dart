import 'package:flutter/cupertino.dart';
import 'package:solut/shared/data_calsses/suit_data_class.dart';

import '../theme/app_colors.dart';
import '../utils/card_utils.dart';

class CardCell extends StatelessWidget {
  const CardCell({super.key, required SuitDataClass suit}) : _suit = suit;

  final SuitDataClass _suit;

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
          CardUtils.getIcon(_suit.type),
          color: CardUtils.getColor(_suit.color),
          size: 40,
        ),
    );
  }

}
