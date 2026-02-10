import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solut/shared/consts/card_sizes.dart';
import 'package:solut/shared/consts/card_type.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';
import 'package:solut/shared/data_calsses/suit_data_class.dart';
import 'package:solut/shared/theme/app_colors.dart';
import 'package:solut/shared/ui%20kit/card_cell.dart';

import '../../../shared/repositories/data.dart';
import '../../../shared/ui kit/suit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SuitCardDataClass> _uncategorized = List.empty(growable: true);

  final List<SuitCardDataClass> _clubs = List.empty(growable: true);
  final List<SuitCardDataClass> _spades = List.empty(growable: true);
  final List<SuitCardDataClass> _diamonds = List.empty(growable: true);
  final List<SuitCardDataClass> _hearts = List.empty(growable: true);

  final List<SuitCardDataClass> _column1 = List.empty(growable: true);
  final List<SuitCardDataClass> _column2 = List.empty(growable: true);
  final List<SuitCardDataClass> _column3 = List.empty(growable: true);
  final List<SuitCardDataClass> _column4 = List.empty(growable: true);
  final List<SuitCardDataClass> _column5 = List.empty(growable: true);
  final List<SuitCardDataClass> _column6 = List.empty(growable: true);
  final List<SuitCardDataClass> _column7 = List.empty(growable: true);

  final ValueNotifier<int> _fromColumn = ValueNotifier(0);
  final ValueNotifier<int> _startIndex = ValueNotifier(-1);

  static const double offset = 20;

  double shrinkExtent = 1;

  List<SuitCardDataClass> getColumnValues(int index, int length) {
    List<SuitCardDataClass> currentList = [];
    for (int i = index; i < length + index; i++) {
      currentList.add(cards[i]);
    }
    return currentList;
  }

  List<SuitCardDataClass> getCardsWithOffset(
    DragTargetDetails<SuitCardDataClass> details,
    List<SuitCardDataClass> target,
  ) {
    return target.sublist(target.indexOf(details.data));
  }

  void replaceCards(
    DragTargetDetails<SuitCardDataClass> details,
    List<SuitCardDataClass> target,
  ) {
    target.removeRange(target.indexOf(details.data), target.length);
    if (target.isNotEmpty) {
      target.last.setFaceUp(true);
    }
  }

  bool checkCardNumberOk(SuitCardDataClass target, SuitCardDataClass dest) {
    return dest.number.index - target.number.index == 1 &&
        target.number.index < dest.number.index;
  }

  bool checkCardSuitOk(SuitCardDataClass target, SuitCardDataClass dest) {
    return dest.suit.color != target.suit.color;
  }

  void handleDrag(
    DragTargetDetails<SuitCardDataClass> details,
    List<SuitCardDataClass> cards,
    int fromColumn,
    int currentColumn,
  ) {
    if (fromColumn == currentColumn) {
      _fromColumn.value = 0;
      return;
    }


    final List<SuitCardDataClass> current = List.empty(growable: true);
    switch (fromColumn) {
      case 1:
        {
          current.addAll(getCardsWithOffset(details, _column1));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column1);
        }
      case 2:
        {
          current.addAll(getCardsWithOffset(details, _column2));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column2);
        }
      case 3:
        {
          current.addAll(getCardsWithOffset(details, _column3));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column3);
        }
      case 4:
        {
          current.addAll(getCardsWithOffset(details, _column4));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column4);
        }
      case 5:
        {
          current.addAll(getCardsWithOffset(details, _column5));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column5);
        }
      case 6:
        {
          current.addAll(getCardsWithOffset(details, _column6));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column6);
        }
      case 7:
        {
          current.addAll(getCardsWithOffset(details, _column7));
          if (cards.isNotEmpty) {
            if (!checkCardNumberOk(current.first, cards.last)) {
              _fromColumn.value = 0;
              return;
            }
          }
          replaceCards(details, _column7);
        }
    }

    if (cards.length + current.length > 9) {
      setState(() {
        shrinkExtent = 0.8;
      });
    } else if (cards.length + current.length <= 12) {
      setState(() {
        shrinkExtent = 0.6;
      });
    }
    cards.addAll(current);
    _fromColumn.value = 0;
  }

  @override
  void initState() {
    cards.shuffle(Random());

    int currentIndex = 0;
    int cardsPerColumn = 1;

    _column1.add(cards[currentIndex]);
    currentIndex++;
    cardsPerColumn++;
    _column1.last.setFaceUp(true);

    _column2.addAll(getColumnValues(currentIndex, cardsPerColumn));
    currentIndex += cardsPerColumn;
    cardsPerColumn++;
    _column2.last.setFaceUp(true);

    _column3.addAll(getColumnValues(currentIndex, cardsPerColumn));
    currentIndex += cardsPerColumn;
    cardsPerColumn++;
    _column3.last.setFaceUp(true);

    _column4.addAll(getColumnValues(currentIndex, cardsPerColumn));
    currentIndex += cardsPerColumn;
    cardsPerColumn++;
    _column4.last.setFaceUp(true);

    _column5.addAll(getColumnValues(currentIndex, cardsPerColumn));
    currentIndex += cardsPerColumn;
    cardsPerColumn++;
    _column5.last.setFaceUp(true);

    _column6.addAll(getColumnValues(currentIndex, cardsPerColumn));
    currentIndex += cardsPerColumn;
    cardsPerColumn++;
    _column6.last.setFaceUp(true);

    _column7.addAll(getColumnValues(currentIndex, cardsPerColumn));
    currentIndex += cardsPerColumn;
    cardsPerColumn++;
    _column7.last.setFaceUp(true);

    cardsPerColumn = cards.length - currentIndex;

    _uncategorized.addAll(getColumnValues(currentIndex, cardsPerColumn));
    _uncategorized.last.setFaceUp(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.viewPaddingOf(context).left + 16,
        right: MediaQuery.viewPaddingOf(context).right + 16,
        top: 24,
        bottom: 24,
      ),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  SuitCard(suitCard: _uncategorized[22]),
                  SuitCard(suitCard: _uncategorized[23]),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  _spades.isNotEmpty
                      ? SuitCard(suitCard: _spades.last)
                      : CardCell(suit: SuitDataClass(type: SuitType.spades, color: SuitColor.black)),
                  _diamonds.isNotEmpty
                      ? Container(
                          color: AppColors.scarlettRush,
                          height: 90,
                          width: 70,
                        )
                      : CardCell(suit: SuitDataClass(type: SuitType.diamonds, color: SuitColor.red)),
                  _clubs.isNotEmpty
                      ? Container(
                          color: AppColors.scarlettRush,
                          height: 90,
                          width: 70,
                        )
                      : CardCell(suit: SuitDataClass(type: SuitType.clubs, color: SuitColor.black)),
                  _hearts.isNotEmpty
                      ? Container(
                          color: AppColors.scarlettRush,
                          height: 90,
                          width: 70,
                        )
                      : CardCell(suit: SuitDataClass(type: SuitType.hearts, color: SuitColor.red)),
                ],
              ),
            ],
          ),
          Expanded(
            child: Row(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                column(_column1, 1),
                column(_column2, 2),
                column(_column3, 3),
                column(_column4, 4),
                column(_column5, 5),
                column(_column6, 6),
                column(_column7, 7),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget column(List<SuitCardDataClass> cards, int columnNumber) {
    return Flexible(
      child: ValueListenableBuilder(
        valueListenable: _fromColumn,
        builder: (context, fromColumn, _) => DragTarget<SuitCardDataClass>(
          onAcceptWithDetails: (details) =>
              handleDrag(details, cards, fromColumn, columnNumber),
          builder: (context, accepted, rejected) => ValueListenableBuilder(
            valueListenable: _startIndex,
            builder: (context, startIndex, _) => Stack(
              alignment: AlignmentGeometry.topCenter,
              clipBehavior: Clip.none,
              children: [
                ...cards.map(
                  (item) {

                    final currentIndex = cards.indexOf(item);

                    return Positioned(
                    top: currentIndex.toDouble() * offset * shrinkExtent,
                    child: Draggable(
                      onDragStarted: () {
                        _fromColumn.value = columnNumber;
                        _startIndex.value = currentIndex;
                      },
                      onDraggableCanceled: (velocity, dragOffset) {
                        _fromColumn.value = 0;
                        _startIndex.value = -1;
                      },
                      dragAnchorStrategy: childDragAnchorStrategy,
                      hitTestBehavior: HitTestBehavior.opaque,
                      data: item,
                      feedback: Container(
                        clipBehavior: Clip.none,
                        width: cardWidth,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(),
                        height:
                            cardHeight +
                            (cards.length - currentIndex) *
                                offset *
                                shrinkExtent,
                        child: Stack(
                          alignment: AlignmentGeometry.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            ...cards
                                .sublist(currentIndex)
                                .map(
                                  (innerItem) => Positioned(
                                    top:
                                        (cards.indexOf(innerItem) -
                                            currentIndex) *
                                        offset *
                                        shrinkExtent,
                                    child: SuitCard(suitCard: innerItem),
                                  ),
                                ),
                          ],
                        ),
                      ),

                      child:
                          startIndex <= currentIndex &&
                              columnNumber == fromColumn
                          ? SizedBox()
                          : SuitCard(suitCard: item),
                    ),
                  );}
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
