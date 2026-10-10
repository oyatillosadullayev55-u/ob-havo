import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/weather_models.dart';

/// Kartochkalar ichidagi kichik (harakatsiz) ob-havo ikonkasi.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon({
    super.key,
    required this.kind,
    this.isDay = true,
    this.size = 28,
    this.line = kIcon,
    this.fill = Colors.white,
  });

  final WeatherKind kind;
  final bool isDay;
  final double size;

  /// Kontur rangi
  final Color line;

  /// Bulut ichining rangi (kartochka foni bilan bir xil bo‘lishi kerak)
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: WeatherIconPainter(
          kind: kind,
          isDay: isDay,
          filled: false,
          t: 0,
          line: line,
          fill: fill,
        ),
      ),
    );
  }
}

/// Tepadagi katta, harakatlanuvchi ikonka:
/// quyosh nurlari aylanadi, yomg‘ir tushadi, bulut surilib turadi.
class AnimatedWeatherIcon extends StatefulWidget {
  const AnimatedWeatherIcon({
    super.key,
    required this.kind,
    this.isDay = true,
    this.size = 92,
  });

  final WeatherKind kind;
  final bool isDay;
  final double size;

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: WeatherIconPainter(
              kind: widget.kind,
              isDay: widget.isDay,
              filled: true,
              t: _controller.value,
              line: Colors.white,
              fill: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Ikonkani 100x100 koordinata tizimida chizadi.
/// `filled: true` bo‘lsa to‘la rangli (katta ikonka), aks holda kontur (kichik ikonka).
/// `t` 0..1 oralig‘ida takrorlanuvchi animatsiya vaqti.
class WeatherIconPainter extends CustomPainter {
  const WeatherIconPainter({
    required this.kind,
    required this.isDay,
    required this.filled,
    required this.t,
    required this.line,
    required this.fill,
  });

  final WeatherKind kind;
  final bool isDay;
  final bool filled;
  final double t;
  final Color line;
  final Color fill;

  static const double _stroke = 5;

  // Bulut shakli: uchta doira va tekis asos birlashtirilgan (72 x 47 birlik)
  static final Path _cloud = _buildCloud();

  static Path _buildCloud() {
    var path = Path()
      ..addOval(Rect.fromCircle(center: const Offset(14, 33), radius: 14));
    path = Path.combine(
      PathOperation.union,
      path,
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(34, 21), radius: 21)),
    );
    path = Path.combine(
      PathOperation.union,
      path,
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(57, 32), radius: 15)),
    );
    return Path.combine(
      PathOperation.union,
      path,
      Path()..addRect(const Rect.fromLTWH(14, 33, 43, 14)),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    final sway = math.sin(t * 2 * math.pi) * 2.5;

    switch (kind) {
      case WeatherKind.clear:
        if (isDay) {
          _sun(canvas, const Offset(50, 50), 19);
        } else {
          _moon(canvas, const Offset(50, 50), 30);
        }
        break;
      case WeatherKind.partly:
        if (isDay) {
          _sun(canvas, const Offset(66, 34), 13);
        } else {
          _moon(canvas, const Offset(64, 32), 20);
        }
        _cloudAt(canvas, Offset(6 + sway, 40), 0.95);
        break;
      case WeatherKind.cloudy:
        _cloudAt(canvas, Offset(34 - sway, 12), 0.78, alpha: 0.65);
        _cloudAt(canvas, Offset(4 + sway, 34), 1.05);
        break;
      case WeatherKind.fog:
        _cloudAt(canvas, Offset(14 + sway, 6), 1.0);
        _fog(canvas);
        break;
      case WeatherKind.drizzle:
        _cloudAt(canvas, Offset(14 + sway, 6), 1.0);
        _rain(canvas, heavy: false);
        break;
      case WeatherKind.rain:
        _cloudAt(canvas, Offset(14 + sway, 6), 1.0);
        _rain(canvas, heavy: true);
        break;
      case WeatherKind.snow:
        _cloudAt(canvas, Offset(14 + sway, 6), 1.0);
        _snow(canvas);
        break;
      case WeatherKind.storm:
        _cloudAt(canvas, Offset(14 + sway, 2), 1.0);
        _bolt(canvas);
        break;
    }

    canvas.restore();
  }

  void _sun(Canvas canvas, Offset center, double r) {
    final rotation = t * math.pi / 4; // 8 ta nur: bir aylanish = 45 daraja
    final ray = Paint()
      ..color = kSun
      ..style = PaintingStyle.stroke
      ..strokeWidth = filled ? r * 0.2 : _stroke
      ..strokeCap = StrokeCap.round;

    if (filled) {
      canvas.drawCircle(
        center,
        r * 1.3,
        Paint()
          ..color = kSun.withValues(alpha: 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      canvas.drawCircle(center, r, Paint()..color = kSun);
    } else {
      canvas.drawCircle(center, r, ray);
    }

    for (var i = 0; i < 8; i++) {
      final angle = rotation + i * math.pi / 4;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * (r * 1.45),
        center + direction * (r * 1.85),
        ray,
      );
    }
  }

  void _moon(Canvas canvas, Offset center, double r) {
    final outer = Path()..addOval(Rect.fromCircle(center: center, radius: r));
    final cut = Path()
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(r * 0.5, -r * 0.35),
          radius: r * 0.82,
        ),
      );
    final moon = Path.combine(PathOperation.difference, outer, cut);

    if (filled) {
      canvas.drawPath(moon, Paint()..color = kMoon);
    } else {
      canvas.drawPath(
        moon,
        Paint()
          ..color = kSun
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  void _cloudAt(Canvas canvas, Offset origin, double scale,
      {double alpha = 1}) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(scale);

    if (filled) {
      canvas.drawPath(
        _cloud.shift(const Offset(0, 2.5)),
        Paint()
          ..color = const Color(0x22000000)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }

    canvas.drawPath(_cloud, Paint()..color = fill.withValues(alpha: alpha));

    if (!filled) {
      canvas.drawPath(
        _cloud,
        Paint()
          ..color = line.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke / scale
          ..strokeJoin = StrokeJoin.round,
      );
    }
    canvas.restore();
  }

  void _rain(Canvas canvas, {required bool heavy}) {
    final color = filled ? const Color(0xFFD6ECFF) : line;
    const xs = [32.0, 50.0, 68.0];
    final length = heavy ? 10.0 : 6.0;

    for (var i = 0; i < xs.length; i++) {
      final phase = (t * 3 + i / 3) % 1.0;
      final y = 60 + phase * 28;
      final fade = phase < 0.75 ? 1.0 : (1 - phase) / 0.25;
      final paint = Paint()
        ..color = color.withValues(alpha: fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = heavy ? _stroke : _stroke * 0.8
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(xs[i], y),
        Offset(xs[i] - length * 0.35, y + length),
        paint,
      );
    }
  }

  void _snow(Canvas canvas) {
    final color = filled ? Colors.white : line;
    for (var i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      final x = 32.0 + i * 18 + math.sin((t + i / 3) * 2 * math.pi) * 3;
      final y = 62 + phase * 26;
      final fade = phase < 0.75 ? 1.0 : (1 - phase) / 0.25;
      canvas.drawCircle(
        Offset(x, y),
        3.4,
        Paint()..color = color.withValues(alpha: fade),
      );
    }
  }

  void _fog(Canvas canvas) {
    final shift = math.sin(t * 2 * math.pi) * 3;
    final paint = Paint()
      ..color = filled ? Colors.white.withValues(alpha: 0.85) : line
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(18 + shift, 68), Offset(82 + shift, 68), paint);
    canvas.drawLine(Offset(26 - shift, 79), Offset(90 - shift, 79), paint);
    canvas.drawLine(Offset(18 + shift, 90), Offset(70 + shift, 90), paint);
  }

  void _bolt(Canvas canvas) {
    final flash = (t * 2) % 1.0 < 0.15;
    final path = Path()
      ..moveTo(54, 48)
      ..lineTo(66, 48)
      ..lineTo(58, 64)
      ..lineTo(70, 64)
      ..lineTo(46, 92)
      ..lineTo(52, 72)
      ..lineTo(40, 72)
      ..close();

    if (filled && flash) {
      canvas.drawPath(
        path,
        Paint()
          ..color = kSun.withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
    canvas.drawPath(path, Paint()..color = kSun);
  }

  @override
  bool shouldRepaint(WeatherIconPainter old) =>
      old.kind != kind ||
          old.isDay != isDay ||
          old.filled != filled ||
          old.t != t ||
          old.line != line ||
          old.fill != fill;
}