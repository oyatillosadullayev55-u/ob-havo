import 'package:flutter/material.dart';

/// Ma’lumot yuklanayotganda ko‘rinadigan "skelet" (miltillovchi bo‘sh joylar).
class WeatherSkeleton extends StatefulWidget {
  const WeatherSkeleton({super.key});

  @override
  State<WeatherSkeleton> createState() => _WeatherSkeletonState();
}

class _WeatherSkeletonState extends State<WeatherSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final alpha = 0.18 + 0.14 * _controller.value;

        Widget block(double width, double height, {double radius = 16}) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: alpha),
              borderRadius: BorderRadius.circular(radius),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  block(88, 88, radius: 44),
                  const SizedBox(width: 18),
                  block(140, 64),
                ],
              ),
              const SizedBox(height: 28),
              block(double.infinity, 170, radius: 26),
              const SizedBox(height: 16),
              block(double.infinity, 300, radius: 26),
            ],
          ),
        );
      },
    );
  }
}