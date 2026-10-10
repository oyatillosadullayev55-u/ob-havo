import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';

/// Tepadagi qator: shahar nomi, qidiruv, menyu va sana.
class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.onSearch,
    required this.onMenu,
  });

  final VoidCallback onSearch;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final forecast = c.forecast;
    final place = forecast?.place ?? c.place;
    final title = place == null ? s.appName : place.title(s.myLocation);
    final date = forecast == null ? '' : s.dateTime(forecast.current.time);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onSearch,
                  child: Row(
                    children: [
                      if (place?.isCurrent ?? false) ...[
                        const Icon(Icons.near_me,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: onSearch,
                icon: const Icon(Icons.search, color: Colors.white, size: 26),
              ),
              IconButton(
                onPressed: onMenu,
                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              ),
            ],
          ),
          if (date.isNotEmpty)
            Text(
              date,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
        ],
      ),
    );
  }
}