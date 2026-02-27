import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../data_calsses/suit_card_data_class.dart';

class DragRotatable extends StatelessWidget {
  const DragRotatable({
    super.key,
    required ValueNotifier<Offset> dragDetails,
    required Widget child,
    required Widget feedback,
    SuitCardDataClass? data,
    void Function()? onDragStarted,
    void Function(DragUpdateDetails)? onDragUpdate,
    void Function(Velocity, Offset)? onDraggableCanceled,
    void Function(DraggableDetails)? onDragEnd,
    void Function()? onDragCompleted,
  }) : _dragDetails = dragDetails,
       _child = child,
       _feedback = feedback,
       _data = data,
       _onDragStarted = onDragStarted,
       _onDragUpdate = onDragUpdate,
       _onDraggableCanceled = onDraggableCanceled,
       _onDragCompleted = onDragCompleted,
       _onDragEnd = onDragEnd;

  final ValueNotifier<Offset> _dragDetails;
  final Widget _child;
  final Widget _feedback;
  final SuitCardDataClass? _data;
  final void Function()? _onDragStarted;
  final void Function(DragUpdateDetails)? _onDragUpdate;
  final void Function(Velocity, Offset)? _onDraggableCanceled;
  final void Function(DraggableDetails)? _onDragEnd;
  final void Function()? _onDragCompleted;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      onDragStarted: _onDragStarted,
      onDragUpdate: _onDragUpdate,
      onDraggableCanceled: _onDraggableCanceled,
      onDragEnd: _onDragEnd,
      onDragCompleted: _onDragCompleted,
      dragAnchorStrategy: childDragAnchorStrategy,
      hitTestBehavior: HitTestBehavior.opaque,
      data: _data,
      feedback: ValueListenableBuilder(
        valueListenable: _dragDetails,
        builder: (context, dragOffset, _) => AnimatedRotation(
          turns: lerpDouble(0, 0.125, 0.05 * dragOffset.dx) ?? 0.0,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 50),
          child: _feedback,
        ),
      ),
      child: _child,
    );
  }
}
