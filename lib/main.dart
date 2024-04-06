import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(103, 56, 55, 55),
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: const Text(
            'Moving Gradient Border',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: MovingGradientBorderWidget(
            child: Container(
              width: 200,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  'Button',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MovingGradientBorderWidget extends StatefulWidget {
  final Widget child;

  const MovingGradientBorderWidget({super.key, required this.child});

  @override
  MovingGradientBorderWidgetState createState() =>
      MovingGradientBorderWidgetState();
}

class MovingGradientBorderWidgetState extends State<MovingGradientBorderWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MovingGradientBorderPainter(_animation.value),
          child: widget.child,
        );
      },
    );
  }
}

class MovingGradientBorderPainter extends CustomPainter {
  final double animationValue;

  MovingGradientBorderPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.pink,
        ],
        stops: const [0.0, 0.25, 0.5, 1.0],
        tileMode: TileMode.repeated,
        transform: GradientRotation(2 * pi * animationValue),
      ).createShader(Rect.fromLTWH(
          0, size.height - (size.height * 0.7), size.width, size.height * 0.7))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, size.height - (size.height * 0.7), size.width,
              size.height * 0.7),
          const Radius.circular(12)));

    canvas.drawPath(path, paint);

    // Add shadow below the button
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.repeated,
        transform: GradientRotation(2 * pi * animationValue),
        colors: const [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.pink,
        ],
        stops: const [0.0, 0.25, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(
          0, size.height - (size.height * 0.7), size.width, size.height * 0.7))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);

    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(MovingGradientBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
