import 'package:flutter/material.dart';
import 'package:radial_progress/src/radial_painter.dart';

class RadialProgressWidget extends StatefulWidget {
  const RadialProgressWidget({
    required this.percent,
    this.diameter = 80,
    this.margin,
    this.padding,
    this.progressLineWidth = 10,
    this.bgLineColor,
    this.progressLineColor = Colors.cyan,
    this.centerChild,
    this.enableAnimation = true,
    this.animationDuration,
    super.key,
  });

  final double percent;
  final double diameter;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double progressLineWidth;
  final Color? bgLineColor;
  final Color progressLineColor;
  final Widget? centerChild;
  final bool enableAnimation;
  final Duration? animationDuration;

  @override
  State<RadialProgressWidget> createState() => _RadialProgressWidgetState();
}

class _RadialProgressWidgetState extends State<RadialProgressWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController? _animationController;
  late final Animation<double> _tweenAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _animationController = AnimationController(
        vsync: this,
        duration: widget.animationDuration ?? const Duration(seconds: 1),
      );
      _tweenAnimation =
          Tween(begin: 0.0, end: widget.percent).animate(_animationController!);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return widget.enableAnimation
            ? AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  return RadialProgress(
                    percent: _tweenAnimation.value,
                    diameter: widget.diameter,
                    padding: widget.padding,
                    progressLineWidth: widget.progressLineWidth,
                    bgLineColor: widget.bgLineColor,
                    progressLineColor: widget.progressLineColor,
                    centerChild: widget.centerChild,
                  );
                },
              )
            : RadialProgress(
                percent: widget.percent,
                diameter: widget.diameter,
                padding: widget.padding,
                progressLineWidth: widget.progressLineWidth,
                bgLineColor: widget.bgLineColor,
                progressLineColor: widget.progressLineColor,
                centerChild: widget.centerChild,
              );
      },
    );
  }
}

class RadialProgress extends StatelessWidget {
  const RadialProgress({
    required this.percent,
    this.diameter = 80,
    this.margin,
    this.padding,
    this.progressLineWidth = 10,
    this.bgLineColor,
    this.progressLineColor = Colors.cyan,
    this.centerChild,
    super.key,
  }) : _gapPadding = (progressLineWidth > (diameter / 3))
            ? diameter / 6
            : progressLineWidth / 2;

  final double percent;
  final double diameter;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double progressLineWidth;
  final Color? bgLineColor;
  final Color progressLineColor;
  final Widget? centerChild;

  final double _gapPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      margin: margin ?? EdgeInsets.all(_gapPadding),
      padding: padding,
      child: CustomPaint(
        foregroundPainter: RadialPainter(
          bgColor: bgLineColor ?? Colors.grey.shade200.withOpacity(0.5),
          lineColor: progressLineColor,
          percent: percent,
          width: (progressLineWidth > (diameter / 3))
              ? diameter / 3
              : progressLineWidth,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(_gapPadding),
            child: centerChild,
          ),
        ),
      ),
    );
  }
}