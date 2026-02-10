import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solut/shared/consts/card_sizes.dart';
import 'package:solut/shared/consts/card_type.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';
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

  static const double offset = 20;

  List<SuitCardDataClass> getColumnValues(int index, int length) {
    List<SuitCardDataClass> currentList = [];
    for (int i = index; i < length + index; i++) {
      currentList.add(cards[i]);
    }
    return currentList;
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
            top: 24, bottom: 24),
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
                    SuitCard(
                        suitCard: _uncategorized[26]
                    ),
                    SuitCard(
                      suitCard: _uncategorized[27],
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    _spades.isNotEmpty ?
                    SuitCard(
                        suitCard: _spades.last
                    ) : CardCell(suit: SuitType.spades),
                    _diamonds.isNotEmpty ?
                    Container(
                      color: AppColors.scarlettRush,
                      height: 90,
                      width: 70,
                    ) : CardCell(suit: SuitType.diamonds),
                    _clubs.isNotEmpty ?
                    Container(
                      color: AppColors.scarlettRush,
                      height: 90,
                      width: 70,
                    ) : CardCell(suit: SuitType.clubs),
                    _hearts.isNotEmpty ?
                    Container(
                      color: AppColors.scarlettRush,
                      height: 90,
                      width: 70,
                    ) : CardCell(suit: SuitType.hearts),
                  ],
                ),
              ],
            ),
            // SizedBox(height: 16,),
            Expanded(child: Row(
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
            ))
          ],
        ),
    );
  }

  Widget column(List<SuitCardDataClass> cards, int columnNumber) {
    return Flexible(
        child: ValueListenableBuilder(valueListenable: _fromColumn,
            builder: (context, fromColumn, _) =>
                DragTarget<SuitCardDataClass>(
                    onAcceptWithDetails: (details) {
                      final List<SuitCardDataClass> current = List
                          .empty(growable: true);
                      switch (fromColumn) {
                        case 1:
                          {
                            current.addAll(_column1
                                .sublist(
                                _column1.indexOf(details.data)));
                            _column1.removeRange(
                                _column1.indexOf(details.data),
                                _column1.length);
                          }
                        case 2:
                          {
                            current.addAll(_column2
                                .sublist(
                                _column2.indexOf(details.data)));
                            _column2.removeRange(
                                _column2.indexOf(details.data),
                                _column2.length);
                          }
                        case 3:
                          {
                            current.addAll(_column3
                                .sublist(
                                _column3.indexOf(details.data)));
                            _column3.removeRange(
                                _column3.indexOf(details.data),
                                _column3.length);
                          }
                        case 4:
                          {
                            current.addAll(_column4
                                .sublist(
                                _column4.indexOf(details.data)));
                            _column4.removeRange(
                                _column4.indexOf(details.data),
                                _column4.length);
                          }
                        case 5:
                          {
                            current.addAll(_column5
                                .sublist(
                                _column5.indexOf(details.data)));
                            _column5.removeRange(
                                _column5.indexOf(details.data),
                                _column5.length);
                          }
                        case 6:
                          {
                            current.addAll(_column6
                                .sublist(
                                _column6.indexOf(details.data)));
                            _column6.removeRange(
                                _column6.indexOf(details.data),
                                _column6.length);
                          }
                        case 7:
                          {
                            current.addAll(_column7
                                .sublist(
                                _column7.indexOf(details.data)));
                            _column7.removeRange(
                                _column7.indexOf(details.data),
                                _column7.length);
                          }
                      }
                      cards.addAll(current);
                      _fromColumn.value = 0;
                    },
                    builder: (context, accepted, rejected) =>
                        Stack(
                            alignment: AlignmentGeometry.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              ...cards.map((item) =>
                                  Positioned(
                                      top: cards.indexOf(item)
                                          .toDouble() * offset,
                                      child: Draggable(
                                          onDragStarted: () {
                                            _fromColumn.value = columnNumber;
                                          },
                                          onDraggableCanceled: (
                                              velocity,
                                              dragOffset) {
                                            _fromColumn.value = 0;
                                          },
                                          dragAnchorStrategy: (
                                              draggable, context,
                                              dragOffset) {
                                            return Offset(
                                                cardWidth / 2,
                                                (cardHeight -
                                                    (cards
                                                        .length -
                                                        cards
                                                            .indexOf(
                                                            item)) *
                                                        offset)
                                                    .toDouble());
                                          },
                                          hitTestBehavior: HitTestBehavior
                                              .opaque,
                                          data: item,
                                          feedback: SizedBox(
                                              width: cardWidth,
                                              height: cardHeight +
                                                  (cards.length -
                                                      cards
                                                          .indexOf(
                                                          item)) *
                                                      offset,
                                              child: Stack(
                                                clipBehavior: Clip
                                                    .none,
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ...cards
                                                      .sublist(
                                                      cards
                                                          .indexOf(
                                                          item))
                                                      .map((
                                                      innerItem) =>
                                                      Positioned(
                                                          top: cards
                                                              .indexOf(
                                                              innerItem)
                                                              .toDouble() *
                                                              offset,
                                                          child: SuitCard(
                                                              suitCard: innerItem)
                                                      ))
                                                ],
                                              )),
                                          child: SuitCard(
                                              suitCard: item)
                                      )))
                            ]
                        ))));
  }
}