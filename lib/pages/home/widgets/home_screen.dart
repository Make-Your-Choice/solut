import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solut/shared/consts/card_sizes.dart';
import 'package:solut/shared/consts/card_source.dart';
import 'package:solut/shared/consts/card_type.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';
import 'package:solut/shared/data_calsses/suit_data_class.dart';
import 'package:solut/shared/theme/app_colors.dart';
import 'package:solut/shared/ui%20kit/card_cell.dart';
import 'package:solut/shared/ui%20kit/drag_rotatable.dart';

import '../../../shared/repositories/data.dart';
import '../../../shared/ui kit/suit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SuitCardDataClass> _shuffle = List.empty(growable: true);

  final List<SuitCardDataClass> _clubs = List.empty(growable: true);
  final List<SuitCardDataClass> _spades = List.empty(growable: true);
  final List<SuitCardDataClass> _diamonds = List.empty(growable: true);
  final List<SuitCardDataClass> _hearts = List.empty(growable: true);

  final Map<int, List<SuitCardDataClass>> _columns = {};

  final ValueNotifier<int> _srcColumnIndex = ValueNotifier(-1);
  final ValueNotifier<int> _startCardIndex = ValueNotifier(-1);

  final ValueNotifier<Offset> _dragDetails = ValueNotifier(Offset.zero);

  final ValueNotifier<int> _currentShuffleIndex = ValueNotifier(0);

  static const double offset = 20;

  CardSource _currentSource = CardSource.column;
  double shrinkExtent = 1;

  List<SuitCardDataClass> getColumnValues(int index, int length) {
    List<SuitCardDataClass> currentList = [];
    for (int i = index; i < length + index; i++) {
      currentList.add(cards[i]);
    }
    return currentList;
  }

  List<SuitCardDataClass> getCardsWithOffset(
    DragTargetDetails<SuitCardDataClass> firstCard,
    List<SuitCardDataClass> srcColumn,
  ) {
    return srcColumn.sublist(srcColumn.indexOf(firstCard.data));
  }

  void replaceCards(
    DragTargetDetails<SuitCardDataClass>? firstCard,
    List<SuitCardDataClass>? srcColumn,
  ) {
    switch (_currentSource) {
      case CardSource.column : {
        srcColumn!.removeRange(srcColumn.indexOf(firstCard!.data), srcColumn.length);
        if (srcColumn.isNotEmpty) {
          srcColumn.last.setFaceUp(true);
        }
      }
      case CardSource.shuffle: {
        _shuffle.removeAt(_currentShuffleIndex.value);
      }
    }
  }

  bool checkCardNumberOk(SuitCardDataClass src, SuitCardDataClass dest) {
    return dest.number.index - src.number.index == 1 &&
        src.number.index < dest.number.index;
  }

  bool checkCardSuitOk(SuitCardDataClass src, SuitCardDataClass dest) {
    return dest.suit.color != src.suit.color;
  }

  void handleDrag(DragTargetDetails<SuitCardDataClass> firstCard,
      List<SuitCardDataClass> destColumn,
      int targetIndex,) {
    final List<SuitCardDataClass> targetColumn = List.empty(growable: true);

    switch (_currentSource) {
      case CardSource.column : {
        targetColumn.addAll(
            getCardsWithOffset(firstCard, _columns[targetIndex]!));
      }
      case CardSource.shuffle: {
        targetColumn.add(firstCard.data);
      }
    }

    if (destColumn.isNotEmpty) {
      if (!checkCardNumberOk(targetColumn.first, destColumn.last)) {
        _srcColumnIndex.value = -1;
        return;
      }
    }

    replaceCards(firstCard, _columns[targetIndex]);

    //todo maybe add scroll instead?
    if (destColumn.length + targetColumn.length >= 10) {
      setState(() {
        shrinkExtent = 0.8;
      });
    } else if (destColumn.length + targetColumn.length <= 16 && destColumn.length + targetColumn.length > 10) {
      setState(() {
        shrinkExtent = 0.6;
      });
    }

    destColumn.addAll(targetColumn);
    switch (_currentSource) {
      case CardSource.column : {
        _srcColumnIndex.value = -1;
      }
      case CardSource.shuffle: {

        if (_shuffle.isNotEmpty) {
          if (_shuffle.length - 1 == _currentShuffleIndex.value) {
            _currentShuffleIndex.value = -1;
          } else {
            _currentShuffleIndex.value--;
          }
          _shuffle[_currentShuffleIndex.value].setFaceUp(true);
        }

      }
    }

  }

  @override
  void initState() {
    cards.shuffle(Random());

    int currentIndex = 0;
    int cardsPerColumn = 1;

    for (int i = 0; i < 7; i++) {
      _columns[i] = getColumnValues(currentIndex, cardsPerColumn);
      _columns[i]?.last.setFaceUp(true);
      currentIndex += cardsPerColumn;
      cardsPerColumn++;
    }

    cardsPerColumn = cards.length - currentIndex;

    _shuffle.addAll(getColumnValues(currentIndex, cardsPerColumn));
    _shuffle.first.setFaceUp(true);

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
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shuffleCards(),
                Spacer(),
                suitCells(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ..._columns.entries.map((item) => column(item.value, item.key))
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
      valueListenable: _srcColumnIndex,
      builder: (context, srcColumnIndex, _) => DragTarget<SuitCardDataClass>(
        onAcceptWithDetails: (details) {
          if (srcColumnIndex == columnNumber) {
            _srcColumnIndex.value = -1;
            return;
          }
          handleDrag(details, cards, srcColumnIndex);
        },
        builder: (context, accepted, rejected) => ValueListenableBuilder(
          valueListenable: _startCardIndex,
          builder: (context, startIndex, _) => Stack(
            alignment: AlignmentGeometry.topCenter,
            clipBehavior: Clip.none,
            children: [
              ...cards.map((item) {
                final currentIndex = cards.indexOf(item);

                return Positioned(
                  top: currentIndex.toDouble() * offset * shrinkExtent,
                  child: DragRotatable(
                    dragDetails: _dragDetails,
                    onDragStarted: () {
                      _currentSource = CardSource.column;
                      _srcColumnIndex.value = columnNumber;
                      _startCardIndex.value = currentIndex;
                    },
                    onDragUpdate: (details) {
                      if ((_dragDetails.value.dx - details.delta.dx).abs() >
                          0.5) {
                        _dragDetails.value = details.delta;
                      }
                    },
                    onDraggableCanceled: (velocity, dragOffset) {
                      _dragDetails.value = Offset.zero;
                      _srcColumnIndex.value = -1;
                      _startCardIndex.value = -1;
                    },
                    data: item,
                    feedback: Container(
                      clipBehavior: Clip.none,
                      width: cardWidth,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(),
                      height: cardHeight +
                          (cards.length - currentIndex) *
                              offset *
                              shrinkExtent,
                      child: Stack(
                        alignment: AlignmentGeometry.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          ...cards.sublist(currentIndex).map(
                                (innerItem) =>
                                Positioned(
                                  top: (cards.indexOf(innerItem) -
                                      currentIndex) *
                                      offset *
                                      shrinkExtent,
                                  child: SuitCard(suitCard: innerItem),
                                ),
                          ),
                        ],
                      ),
                    ),
                    child: startIndex <= currentIndex &&
                        columnNumber == srcColumnIndex
                        ? SizedBox()
                        : SuitCard(suitCard: item),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    ));
  }

  Widget shuffleCards() {
    return ValueListenableBuilder(valueListenable: _currentShuffleIndex,
        builder: (context, currentShuffleIndex, _) =>
        _shuffle.isNotEmpty ? Row(
          spacing: 10,
          children: [
            _shuffle.length > 1 ?
            GestureDetector(
                onTap: () {
                  if (currentShuffleIndex == -1) {
                    _currentShuffleIndex.value = 0;
                    _shuffle[_currentShuffleIndex.value].setFaceUp(true);
                  } else {
                    if (currentShuffleIndex == _shuffle.length - 1) {
                      _currentShuffleIndex.value = -1;
                      _shuffle.forEach((item) => item.setFaceUp(false));
                    } else {
                      _currentShuffleIndex.value++;
                      _shuffle[_currentShuffleIndex.value].setFaceUp(true);
                    }
                  }
                },
                child: currentShuffleIndex + 1 == _shuffle.length ? Container(
                  height: 90, width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.teaGreen,
                  ),
                ) : SuitCard(suitCard: _shuffle[currentShuffleIndex + 1])
            ) : Container(
              height: 90, width: 70, decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.teaGreen,
            ),
            ),

            currentShuffleIndex != -1 ?

            DragRotatable(
              dragDetails: _dragDetails,
              onDragStarted: () {
                _currentSource = CardSource.shuffle;
              },
              onDragUpdate: (details) {
                if ((_dragDetails.value.dx - details.delta.dx).abs() >
                    0.5) {
                  _dragDetails.value = details.delta;
                }
              },
              onDraggableCanceled: (velocity, dragOffset) {
                _dragDetails.value = Offset.zero;
              },
              data: _shuffle[currentShuffleIndex],
              feedback: SuitCard(suitCard: _shuffle[currentShuffleIndex]),
              child: SuitCard(suitCard: _shuffle[currentShuffleIndex]),
            ) : Container(
              height: 90, width: 70, decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.teaGreen,
            ),
            ),

          ],
        ) : SizedBox()
    );
  }

  Widget suitCells() {
    return Row(
      spacing: 10,
      children: [
        _spades.isNotEmpty
            ? SuitCard(suitCard: _spades.last)
            : CardCell(
          suit: SuitDataClass(
            type: SuitType.spades,
            color: SuitColor.black,
          ),
        ),
        _diamonds.isNotEmpty
            ? Container(
          color: AppColors.scarlettRush,
          height: 90,
          width: 70,
        )
            : CardCell(
          suit: SuitDataClass(
            type: SuitType.diamonds,
            color: SuitColor.red,
          ),
        ),
        _clubs.isNotEmpty
            ? Container(
          color: AppColors.scarlettRush,
          height: 90,
          width: 70,
        )
            : CardCell(
          suit: SuitDataClass(
            type: SuitType.clubs,
            color: SuitColor.black,
          ),
        ),
        _hearts.isNotEmpty
            ? Container(
          color: AppColors.scarlettRush,
          height: 90,
          width: 70,
        )
            : CardCell(
          suit: SuitDataClass(
            type: SuitType.hearts,
            color: SuitColor.red,
          ),
        ),
      ],
    );
  }
}
