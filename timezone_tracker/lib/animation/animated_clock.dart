import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AnimatedClock extends StatefulWidget {
  final String timezone;

  const AnimatedClock({required this.timezone});

  @override
  _AnimatedClockState createState() => _AnimatedClockState();
}

class _AnimatedClockState extends State<AnimatedClock> {
  late Timer _timer;
  late tz.TZDateTime _currentTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _currentTime = tz.TZDateTime.now(tz.getLocation(widget.timezone));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = tz.TZDateTime.now(tz.getLocation(widget.timezone));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          painter: ClockPainter(_currentTime),
          child: const SizedBox(
            width: 120,
            height: 120,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('yyyy-MM-dd').format(_currentTime),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  final tz.TZDateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY);

    var facePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);

    final hourHandAngle = (dateTime.hour + dateTime.minute / 60) * 2 * pi / 12;
    final minuteHandAngle = dateTime.minute * 2 * pi / 60;
    final secondHandAngle = dateTime.second * 2 * pi / 60;

    _drawHand(canvas, center, hourHandAngle, radius * 0.5, 8);
    _drawHand(canvas, center, minuteHandAngle, radius * 0.7, 6);
    _drawHand(canvas, center, secondHandAngle, radius * 0.9, 4,
        color: Colors.red);
  }

  void _drawHand(Canvas canvas, Offset center, double angle, double length,
      double strokeWidth,
      {Color color = Colors.black}) {
    final handPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    final position = center + Offset(sin(angle), -cos(angle)) * length;
    canvas.drawLine(center, position, handPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
