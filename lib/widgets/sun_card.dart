import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import 'app_card.dart';

/// Quyosh chiqishi va botishi: yoy ustida quyosh hozir qayerdaligi ko‘rinadi.
class SunCard extends StatelessWidget {
  const SunCard({super.key, required this.forecast});

  final Forecast forecast;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final p = c.palette;
    final today = forecast.days.first;
    final sunrise = today.sunrise;
    final sunset = today.sunset;
    if (sunrise == null || sunset == null) return const SizedBox.shrink();

    final total = sunset.difference(sunrise).inMinutes;
    final passed = forecast.current.time.difference(sunrise).inMinutes;
    final progress =
    total <= 0 ? 0.0 : math.max(0.0, math.min(1.0, passed / total));

    return AppCard(
      palette: p,
      child: Column(
        children: [
          SizedBox(
            height: 96,
            width: double.infinity,
            child: CustomPaint(
              painter: SunArcPainter(
                progress: progress,
                track: p.onCard.withValues(alpha: 0.14),
                line: p.accent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimeBlock(
                label: s.sunrise,
                time: s.clock(sunrise),
                labelColor: p.muted,
                timeColor: p.onCard,
                alignment: CrossAxisAlignment.start,
              ),
              _TimeBlock(
                label: s.sunset,
                time: s.clock(sunset),
                labelColor: p.muted,
                timeColor: p.onCard,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.label,
    required this.time,
    required this.labelColor,
    required this.timeColor,
    required this.alignment,
  });

  final String label;
  final String time;
  final Color labelColor;
  final Color timeColor;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            color: timeColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class SunArcPainter extends CustomPainter {
  const SunArcPainter({
    required this.progress,
    required this.track,
    required this.line,
  });

  /// 0 = quyosh chiqdi, 1 = quyosh botdi
  final double progress;
  final Color track;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final baseY = size.height - 8;
    final rx = size.width / 2 - 14;
    final ry = size.height - 22;

    final arc = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(cx, baseY),
          width: rx * 2,
          height: ry * 2,
        ),
        math.pi,
        math.pi,
      );

    canvas.drawPath(
      arc,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Gorizont chizig‘i
    canvas.drawLine(
      Offset(4, baseY),
      Offset(size.width - 4, baseY),
      Paint()
        ..color = track
        ..strokeWidth = 1.5,
    );

    if (progress > 0) {
      final metric = arc.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * progress),
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    final angle = math.pi + math.pi * progress;
    final sun = Offset(
      cx + rx * math.cos(angle),
      baseY + ry * math.sin(angle),
    );
    canvas.drawCircle(
      sun,
      13,
      Paint()
        ..color = kSun.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(sun, 7.5, Paint()..color = kSun);
  }

  @override
  bool shouldRepaint(SunArcPainter old) =>
      old.progress != progress || old.track != track || old.line != line;
}