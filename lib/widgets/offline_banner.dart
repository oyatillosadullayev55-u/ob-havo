import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';

/// Internet yo‘qligida, eski ma’lumot ko‘rsatilayotganini bildiradi.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    required this.updatedAt,
    required this.onRetry,
  });

  final DateTime updatedAt;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = WeatherScope.of(context).s;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 16, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              s.offlineBanner(s.clock(updatedAt)),
              style: const TextStyle(color: Colors.white, fontSize: 12.5),
            ),
          ),
          IconButton(
            onPressed: onRetry,
            tooltip: s.retry,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}