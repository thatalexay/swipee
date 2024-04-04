library swipee;

import 'package:flutter/material.dart';

class Swipee extends StatefulWidget {
  /// width of widget
  final double width;

  /// height of widget
  final double height;

  /// width of track
  final double trackWidth;

  /// height of track
  final double trackHeight;

  /// width of draggable button
  final double? buttonWidth;

  /// height of draggable button
  final double? buttonHeight;

  /// label to display on button, if child is not provided. N.B. label and child cannot be provided at the same time
  final String? label;

  /// child to display on button, if label is not provided. N.B. label and child cannot be provided at the same time
  final Widget? child;

  /// color of draggable button
  final Color? color;

  /// child to display on track
  final Widget? trackChild;

  /// color of track
  final Color? trackColor;

  /// direction to swipe, Axis.horizontal or Axis.vertical
  final Axis? axis;

  /// callback function to execute when button is swiped
  final Function? onSwipe;

  /// radius of button and track
  final double radius;
  const Swipee(
      {this.width = 200,
      this.height = 50,
      this.trackWidth = 200,
      this.trackHeight = 50,
      this.label,
      this.child,
      this.buttonWidth,
      this.buttonHeight,
      this.color = Colors.black,
      this.trackChild,
      this.trackColor = Colors.grey,
      this.axis = Axis.horizontal,
      this.onSwipe,
      this.radius = 50,
      super.key})
      : assert(label == null || child == null, "Cannot provide both label and child"),
        assert(axis == Axis.horizontal || axis == Axis.vertical, "Axis must be either horizontal or vertical");

  @override
  State<Swipee> createState() => _SwipeeState();
}

class _SwipeeState extends State<Swipee> with TickerProviderStateMixin {
  late AnimationController _swipeAnimationController;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    super.dispose();
  }

  double _getButtonWidth(BoxConstraints constraints) {
    int d = widget.axis == Axis.horizontal ? 2 : 1;
    return widget.buttonWidth ?? widget.trackWidth / d;
  }

  double _getButtonHeight(BoxConstraints constraints) {
    int d = widget.axis == Axis.vertical ? 2 : 1;

    return widget.buttonHeight ?? widget.trackHeight / d;
  }

  void _initAnimationController() {
    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 1,
      value: 0,
    );
  }

  Widget _buildTrack(BuildContext context, BoxConstraints constraints) {
    return Container(
      width: widget.trackWidth,
      height: widget.trackHeight,
      decoration: BoxDecoration(
        color: widget.trackColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Center(child: widget.trackChild),
    );
  }

  Widget _buildButton(BuildContext context, BoxConstraints constraints) {
    return AnimatedBuilder(
        animation: _swipeAnimationController,
        builder: (context, child) {
          double xOffset = widget.axis == Axis.horizontal ? constraints.maxWidth * _swipeAnimationController.value : 0;
          xOffset = widget.axis == Axis.horizontal && xOffset > constraints.maxWidth - _getButtonWidth(constraints) ? constraints.maxWidth - _getButtonWidth(constraints) : xOffset;
          double yOffset = widget.axis == Axis.vertical ? constraints.maxHeight * _swipeAnimationController.value : 0;
          yOffset = widget.axis == Axis.vertical && yOffset > constraints.maxHeight - _getButtonHeight(constraints) ? constraints.maxHeight - _getButtonHeight(constraints) : yOffset;

          return Transform.translate(
              offset: Offset(xOffset, yOffset),
              child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (widget.axis == Axis.horizontal) {
                      _swipeAnimationController.value += details.primaryDelta! / constraints.maxWidth;
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (_swipeAnimationController.value > 0.5) {
                      _swipeAnimationController.forward();
                      widget.onSwipe!();
                      _swipeAnimationController.reverse();
                    } else {
                      _swipeAnimationController.reverse();
                    }
                  },
                  onVerticalDragUpdate: (details) {
                    if (widget.axis == Axis.vertical) {
                      _swipeAnimationController.value += details.primaryDelta! / constraints.maxHeight;
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (_swipeAnimationController.value > 0.5) {
                      _swipeAnimationController.forward();
                      widget.onSwipe!();
                      _swipeAnimationController.reverse();
                    } else {
                      _swipeAnimationController.reverse();
                    }
                  },
                  child: Container(
                    width: _getButtonWidth(constraints),
                    height: _getButtonHeight(constraints),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ),
                    child: Center(child: widget.child ?? Text(widget.label ?? "SWIPE", style: TextStyle(color: Colors.white))),
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: LayoutBuilder(builder: (context, constraints) {
          // center button according to size of widget
          double buttonX = widget.axis == Axis.horizontal ? 0 : (widget.width - _getButtonWidth(constraints)) / 2;
          double buttonY = widget.axis == Axis.vertical ? 0 : (widget.height - _getButtonHeight(constraints)) / 2;

          return Stack(children: [
            Center(child: _buildTrack(context, constraints)),
            Positioned(top: buttonY, left: buttonX, child: _buildButton(context, constraints)),
          ]);
        }));
  }
}
