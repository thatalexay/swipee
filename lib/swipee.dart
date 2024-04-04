/// Support for doing something awesome.
///
/// More dartdocs go here.
library swipee;

import 'package:flutter/material.dart';

class Swipee extends StatefulWidget {
  final double? height;
  final double? width;
  final double? trackWidth;
  final double? trackHeight;
  final double? buttonWidth;
  final double? buttonHeight;
  final String? label;
  final Widget? child;

  final Color? color;
  final Widget? trackChild;
  final Color? trackColor;

  final Axis? axis;
  final Function? onSwipe;
  final int? elevation;
  const Swipee(
      {this.width = double.infinity,
      this.height = 30,
      this.elevation,
      this.trackWidth,
      this.trackHeight,
      this.label,
      this.child,
      this.buttonWidth,
      this.buttonHeight,
      this.color,
      this.trackChild,
      this.trackColor,
      this.axis = Axis.horizontal,
      this.onSwipe,
      super.key})
      : assert(label == null || child == null, "Cannot provide both label and child");

  @override
  State<Swipee> createState() => _SwipeeState();
}

class _SwipeeState extends State<Swipee> with TickerProviderStateMixin {
  late AnimationController _swipeAnimationController;

  @override
  void initState() {
    super.initState();
    initAnimationController();
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    super.dispose();
  }

  double getButtonWidth(BoxConstraints constraints) {
    int d = widget.axis == Axis.horizontal ? 2 : 1;

    return widget.buttonWidth != null
        ? widget.buttonWidth!
        : widget.trackWidth != null
            ? widget.trackWidth! / d
            : constraints.maxWidth / d;
  }

  double getButtonHeight(BoxConstraints constraints) {
    int d = widget.axis == Axis.vertical ? 2 : 1;

    return widget.buttonHeight != null
        ? widget.buttonHeight!
        : widget.trackHeight != null
            ? widget.trackHeight! / d
            : constraints.maxHeight / d;
  }

  void initAnimationController() {
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
      width: widget.trackWidth ?? constraints.maxWidth,
      height: widget.trackHeight ?? constraints.maxHeight,
      decoration: BoxDecoration(
        color: widget.trackColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(child: widget.trackChild),
    );
  }

  Widget _buildButton(BuildContext context, BoxConstraints constraints) {
    return AnimatedBuilder(
        animation: _swipeAnimationController,
        builder: (context, child) {
          double xOffset = widget.axis == Axis.horizontal ? constraints.maxWidth * _swipeAnimationController.value : 0;
          xOffset = widget.axis == Axis.horizontal && xOffset > constraints.maxWidth - getButtonWidth(constraints) ? constraints.maxWidth - getButtonWidth(constraints) : xOffset;
          double yOffset = widget.axis == Axis.vertical ? constraints.maxHeight * _swipeAnimationController.value : 0;
          yOffset = widget.axis == Axis.vertical && yOffset > constraints.maxHeight - getButtonHeight(constraints) ? constraints.maxHeight - getButtonHeight(constraints) : yOffset;

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
                    width: getButtonWidth(constraints),
                    height: getButtonHeight(constraints),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(child: widget.child ?? const Text("SWIPE", style: TextStyle(color: Colors.white))),
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(children: [
            _buildTrack(context, constraints),
            _buildButton(context, constraints),
          ]);
        }));
  }
}
