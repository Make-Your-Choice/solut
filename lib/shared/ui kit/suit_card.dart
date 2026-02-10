import 'package:flutter/cupertino.dart';
import 'package:solut/shared/consts/card_sizes.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

import '../theme/app_colors.dart';
import '../utils/card_utils.dart';

class SuitCard extends StatelessWidget {
  const SuitCard({super.key, required SuitCardDataClass suitCard})
    : _suitCard = suitCard;

  final SuitCardDataClass _suitCard;

  //todo make turn faces
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _suitCard.isFaceUp
          ? EdgeInsets.symmetric(horizontal: 5, vertical: 2)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _suitCard.isFaceUp ? AppColors.beige : AppColors.lemonChiffon,
        border: Border.all(
          color: _suitCard.isFaceUp
              ? CardUtils.getColor(_suitCard.suit.color)
              : AppColors.lightBronze,
        ),
      ),
      height: cardHeight,
      width: cardWidth,
      child: _suitCard.isFaceUp
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CardUtils.getTitle(_suitCard.number),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkCoffee,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none
                      ),
                    ),
                    Icon(
                      CardUtils.getIcon(_suitCard.suit.type),
                      color: CardUtils.getColor(_suitCard.suit.color),
                      size: 15,
                    ),
                  ],
                ),
                Icon(
                  CardUtils.getIcon(_suitCard.suit.type),
                  color: CardUtils.getColor(_suitCard.suit.color),
                  size: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CardUtils.getIcon(_suitCard.suit.type),
                      color: CardUtils.getColor(_suitCard.suit.color),
                      size: 15,
                    ),
                    Text(
                      CardUtils.getTitle(_suitCard.number),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkCoffee,
                        fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Icon(
              CupertinoIcons.burst_fill,
              size: 40,
              color: AppColors.lightBronze,
            ),
    );
  }
}
