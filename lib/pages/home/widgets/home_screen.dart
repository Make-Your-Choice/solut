import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solut/shared/consts/card_number.dart';
import 'package:solut/shared/consts/card_sizes.dart';
import 'package:solut/shared/consts/card_source.dart';
import 'package:solut/shared/consts/card_type.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';
import 'package:solut/shared/data_calsses/suit_data_class.dart';
import 'package:solut/shared/providers/clubs_provider.dart';
import 'package:solut/shared/providers/columns_provider.dart';
import 'package:solut/shared/providers/current_card_source_provider.dart';
import 'package:solut/shared/providers/diamonds_provider.dart';
import 'package:solut/shared/providers/hearts_provider.dart';
import 'package:solut/shared/providers/shuffle_provider.dart';
import 'package:solut/shared/providers/source_column_index_provider.dart';
import 'package:solut/shared/providers/spades_provider.dart';
import 'package:solut/shared/theme/app_colors.dart';
import 'package:solut/shared/ui%20kit/card_cell.dart';
import 'package:solut/shared/ui%20kit/drag_rotatable.dart';

import '../../../shared/repositories/data.dart';
import '../../../shared/ui kit/suit_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ValueNotifier<int> _startCardIndex = ValueNotifier(-1);

  final ValueNotifier<Offset> _dragDetails = ValueNotifier(Offset.zero);

  final ValueNotifier<int> _currentShuffleIndex = ValueNotifier(-1);

  static const double offset = 20;

  double shrinkExtent = 1;

  List<SuitCardDataClass> getColumnValues(int index, int length) {
    List<SuitCardDataClass> currentList = [];
    for (int i = index; i < length + index; i++) {
      currentList.add(cards[i]);
    }
    return currentList;
  }

  bool checkCardNumberOkDesc(SuitCardDataClass src, SuitCardDataClass dest) {
    return dest.number.index - src.number.index == 1 &&
        src.number.index < dest.number.index;
  }

  bool checkCardNumberOkAsc(SuitCardDataClass src, SuitCardDataClass dest) {
    return src.number.index - dest.number.index == 1 &&
        dest.number.index < src.number.index;
  }

  bool checkCardDifferentSuit(SuitCardDataClass src, SuitCardDataClass dest) {
    return dest.suit.color != src.suit.color && dest.suit.type != src.suit.type;
  }

  bool checkReplaceToColumn(SuitCardDataClass src, SuitCardDataClass dest) {
    return checkCardNumberOkDesc(src, dest) &&
        checkCardDifferentSuit(src, dest);
  }

  bool checkReplaceToSuitCell(SuitCardDataClass src, SuitCardDataClass? dest) {
    return dest == null && src.number == CardNumber.A ||
        dest != null &&
            checkCardNumberOkAsc(src, dest) &&
            !checkCardDifferentSuit(src, dest);
  }

  void updateShrink(int columnLength) {
    //todo maybe add scroll instead?
    if (columnLength >= 10) {
      setState(() {
        shrinkExtent = 0.8;
      });
    } else if (columnLength <= 16 && columnLength > 10) {
      setState(() {
        shrinkExtent = 0.6;
      });
    }
  }

  void handleDragColumn(
    DragTargetDetails<SuitCardDataClass> firstCard,
    int destIndex,
    int srcIndex,
  ) {
    if (ref.read(columnsProvider)[destIndex]!.isNotEmpty) {
      if (!checkReplaceToColumn(
        firstCard.data,
        ref.read(columnsProvider)[destIndex]!.last,
      )) {
        ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
        return;
      }
    }

    final List<SuitCardDataClass> targetColumn = ref
        .read(columnsProvider)[srcIndex]!
        .sublist(ref.read(columnsProvider)[srcIndex]!.indexOf(firstCard.data));

    ref
        .read(columnsProvider.notifier)
        .removeFromColumn(srcIndex, firstCard.data);
    ref.read(columnsProvider.notifier).setLastFaceUp(srcIndex);

    updateShrink(
      ref.read(columnsProvider)[destIndex]!.length + targetColumn.length,
    );

    ref.read(columnsProvider.notifier).addAllToColumn(destIndex, targetColumn);
    ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
  }

  void handleDragShuffle(
    DragTargetDetails<SuitCardDataClass> firstCard,
    int destIndex,
  ) {
    if (ref.read(columnsProvider)[destIndex]!.isNotEmpty) {
      if (!checkReplaceToColumn(
        firstCard.data,
        ref.read(columnsProvider)[destIndex]!.last,
      )) {
        ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
        return;
      }
    }

    ref.read(shuffleProvider.notifier).removeAt(_currentShuffleIndex.value);

    updateShrink(ref.read(columnsProvider)[destIndex]!.length + 1);

    ref.read(columnsProvider.notifier).addToColumn(destIndex, firstCard.data);
    if (_currentShuffleIndex.value == ref.read(shuffleProvider).length - 1 ||
        _currentShuffleIndex.value == 0) {
      _currentShuffleIndex.value = -1;
      ref.read(shuffleProvider.notifier).setAllFaceDown();
      return;
    }
    _currentShuffleIndex.value--;
    ref
        .read(shuffleProvider.notifier)
        .setFaceUp(_currentShuffleIndex.value, isFaceUp: true);
  }

  void handleDragSuitCell(
    DragTargetDetails<SuitCardDataClass> firstCard,
    List<SuitCardDataClass> destColumn,
    int? srcIndex,
  ) {
    if (!checkReplaceToSuitCell(
      firstCard.data,
      destColumn.isNotEmpty ? destColumn.last : null,
    )) {
      ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
      return;
    }

    if (srcIndex != null) {
      if (ref.read(columnsProvider)[srcIndex]!.indexOf(firstCard.data) !=
          ref.read(columnsProvider)[srcIndex]!.length - 1) {
        ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
        return;
      }
    }

    switch (ref.read(currentCardsSourceProvider)) {
      case CardSource.column:
        {
          ref.read(columnsProvider.notifier).removeLastFromColumn(srcIndex!);
          ref.read(columnsProvider.notifier).setLastFaceUp(srcIndex);
        }
      case CardSource.shuffle:
        {
          ref
              .read(shuffleProvider.notifier)
              .removeAt(_currentShuffleIndex.value);
        }
    }

    updateShrink(destColumn.length + 1);

    destColumn.add(firstCard.data);
    switch (ref.read(currentCardsSourceProvider)) {
      case CardSource.column:
        {
          ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
        }
      case CardSource.shuffle:
        {
          if (_currentShuffleIndex.value ==
                  ref.read(shuffleProvider).length - 1 ||
              _currentShuffleIndex.value == 0) {
            _currentShuffleIndex.value = -1;
            ref.read(shuffleProvider.notifier).setAllFaceDown();
            return;
          }
          _currentShuffleIndex.value--;
          ref
              .read(shuffleProvider.notifier)
              .setFaceUp(_currentShuffleIndex.value, isFaceUp: true);
        }
    }
  }

  @override
  void initState() {
    cards.shuffle(Random());

    Future.microtask(() {
      int currentIndex = 0;
      int cardsPerColumn = 1;

      for (int i = 0; i < 7; i++) {
        ref
            .read(columnsProvider.notifier)
            .addAllToColumn(i, getColumnValues(currentIndex, cardsPerColumn));
        ref.read(columnsProvider.notifier).setLastFaceUp(i);
        currentIndex += cardsPerColumn;
        cardsPerColumn++;
      }

      cardsPerColumn = cards.length - currentIndex;

      ref
          .read(shuffleProvider.notifier)
          .addAll(getColumnValues(currentIndex, cardsPerColumn));
    });

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
              Flexible(child: shuffleCards()),
              Expanded(child: suitCells()),
            ],
          ),
          Expanded(
            child: Row(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...ref
                    .watch(columnsProvider)
                    .entries
                    .map((item) => column(item.value, item.key)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget column(List<SuitCardDataClass> cards, int columnNumber) {
    return Flexible(
      child: DragTarget<SuitCardDataClass>(
            onAcceptWithDetails: (details) {
              if (ref.watch(sourceColumnIndexProvider) == columnNumber) {
                ref.read(sourceColumnIndexProvider.notifier).setIndex(-1);
                return;
              }
              if (ref.read(currentCardsSourceProvider) == CardSource.column) {
                handleDragColumn(
                  details,
                  columnNumber,
                  ref.read(sourceColumnIndexProvider),
                );
              } else {
                handleDragShuffle(details, columnNumber);
              }
              _dragDetails.value = Offset.zero;
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
                          ref
                              .read(currentCardsSourceProvider.notifier)
                              .setSource(CardSource.column);
                          ref
                              .read(sourceColumnIndexProvider.notifier)
                              .setIndex(columnNumber);
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
                          ref
                              .read(sourceColumnIndexProvider.notifier)
                              .setIndex(-1);
                          _startCardIndex.value = -1;
                        },
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
                                columnNumber ==
                                    ref.watch(sourceColumnIndexProvider)
                            ? SizedBox()
                            : SuitCard(suitCard: item),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
    );
  }

  Widget shuffleCards() {
    return ValueListenableBuilder(
      valueListenable: _currentShuffleIndex,
      builder: (context, currentShuffleIndex, _) =>
          ref.watch(shuffleProvider).isNotEmpty
          ? Row(
              spacing: 10,
              children: [
                shuffleFaceDown(currentShuffleIndex),
                shuffleFaceUp(currentShuffleIndex),
              ],
            )
          : SizedBox(),
    );
  }

  Widget shuffleFaceDown(int index) {
    return ref.watch(shuffleProvider).length > 1
        ? GestureDetector(
            onTap: () {
              if (index == -1) {
                ref.read(shuffleProvider.notifier).setFaceUp(0, isFaceUp: true);
                _currentShuffleIndex.value = 0;
                return;
              }
              if (index == ref.read(shuffleProvider).length - 1) {
                ref.read(shuffleProvider.notifier).setAllFaceDown();
                _currentShuffleIndex.value = -1;
                return;
              }

              ref
                  .read(shuffleProvider.notifier)
                  .setFaceUp(index + 1, isFaceUp: true);
              _currentShuffleIndex.value++;
            },
            child: index == ref.watch(shuffleProvider).length - 1
                ? Container(
                    height: 90,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.teaGreen,
                    ),
                  )
                : SuitCard(suitCard: ref.watch(shuffleProvider)[index + 1]),
          )
        : Container(
            height: 90,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.teaGreen,
            ),
          );
  }

  Widget shuffleFaceUp(int index) {
    return index != -1
        ? DragRotatable(
            dragDetails: _dragDetails,
            onDragStarted: () {
              ref
                  .read(currentCardsSourceProvider.notifier)
                  .setSource(CardSource.shuffle);
            },
            onDragUpdate: (details) {
              if ((_dragDetails.value.dx - details.delta.dx).abs() > 0.5) {
                _dragDetails.value = details.delta;
              }
            },
            onDraggableCanceled: (velocity, dragOffset) {
              _dragDetails.value = Offset.zero;
            },
            data: ref.watch(shuffleProvider)[index],
            feedback: SuitCard(suitCard: ref.watch(shuffleProvider)[index]),
            child: ValueListenableBuilder(
              valueListenable: _dragDetails,
              builder: (context, dragDetails, _) =>
                  ref.watch(currentCardsSourceProvider) == CardSource.shuffle &&
                      dragDetails != Offset.zero
                  ? index == 0
                        ? Container(
                            height: 90,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.teaGreen,
                            ),
                          )
                        : SuitCard(
                            suitCard: ref.watch(shuffleProvider)[index - 1],
                          )
                  : SuitCard(suitCard: ref.watch(shuffleProvider)[index]),
            ),
          )
        : Container(
            height: 90,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.teaGreen,
            ),
          );
  }

  Widget suitCells() {
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: suitCell(
            ref.watch(spadesProvider),
            SuitDataClass(type: SuitType.spades, color: SuitColor.black),
          ),
        ),
        Flexible(
          child: suitCell(
            ref.watch(diamondsProvider),
            SuitDataClass(type: SuitType.diamonds, color: SuitColor.red),
          ),
        ),
        Flexible(
          child: suitCell(
            ref.watch(clubsProvider),
            SuitDataClass(type: SuitType.clubs, color: SuitColor.black),
          ),
        ),
        Flexible(
          child: suitCell(
            ref.watch(heartsProvider),
            SuitDataClass(type: SuitType.hearts, color: SuitColor.red),
          ),
        ),
      ],
    );
  }

  Widget suitCell(List<SuitCardDataClass> cards, SuitDataClass emptyState) {
    return DragTarget<SuitCardDataClass>(
      onAcceptWithDetails: (details) {
        handleDragSuitCell(
          details,
          cards,
          ref.read(currentCardsSourceProvider) == CardSource.column
              ? ref.read(sourceColumnIndexProvider)
              : null,
        );
        _dragDetails.value = Offset.zero;
      },
      builder: (context, accepted, rejected) => cards.isNotEmpty
          ? SuitCard(suitCard: cards.last)
          : CardCell(suit: emptyState),
    );
  }
}
