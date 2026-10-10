import 'package:flutter/material.dart';

import '../controllers/weather_scope.dart';
import '../models/weather_models.dart';
import '../utils/l10n.dart';
import '../utils/units.dart';
import 'segmented.dart';

/// Menyu (o‘ng tomondan chiqadi): joylashuv, saqlangan shaharlar va sozlamalar.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.onOpenSearch});

  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final s = c.s;
    final p = c.palette;

    return Drawer(
      backgroundColor: p.bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: p.gradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _DrawerAction(
                icon: Icons.my_location,
                label: s.myLocation,
                onTap: () {
                  Navigator.of(context).pop();
                  c.useMyLocation();
                },
              ),
              const SizedBox(height: 8),
              _DrawerAction(
                icon: Icons.add_location_alt_outlined,
                label: s.addCity,
                onTap: () {
                  Navigator.of(context).pop();
                  onOpenSearch();
                },
              ),
              const SizedBox(height: 24),
              _SectionTitle(s.savedCities),
              if (c.favorites.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    s.noSavedCities,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                )
              else
                for (final city in c.favorites)
                  _SavedCityTile(
                    place: city,
                    removeTooltip: s.removeCity,
                    onTap: () {
                      Navigator.of(context).pop();
                      c.selectPlace(city);
                    },
                    onRemove: () => c.removeFavorite(city),
                  ),
              const SizedBox(height: 24),
              _SectionTitle(s.settings),
              _SettingLabel(s.temperature),
              Segmented<TempUnit>(
                values: TempUnit.values,
                selected: c.tempUnit,
                labelOf: (unit) => unit == TempUnit.celsius ? '°C' : '°F',
                onChanged: c.setTempUnit,
              ),
              const SizedBox(height: 16),
              _SettingLabel(s.windSpeed),
              Segmented<WindUnit>(
                values: WindUnit.values,
                selected: c.windUnit,
                labelOf: s.windUnitLabel,
                onChanged: c.setWindUnit,
              ),
              const SizedBox(height: 16),
              _SettingLabel(s.language),
              Segmented<AppLanguage>(
                values: AppLanguage.values,
                selected: c.language,
                labelOf: (language) => language.label,
                onChanged: c.setLanguage,
              ),
              const SizedBox(height: 28),
              Text(
                s.dataBy,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SettingLabel extends StatelessWidget {
  const _SettingLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 13,
        ),
      ),
    );
  }
}

class _DrawerAction extends StatelessWidget {
  const _DrawerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedCityTile extends StatelessWidget {
  const _SavedCityTile({
    required this.place,
    required this.removeTooltip,
    required this.onTap,
    required this.onRemove,
  });

  final GeoPlace place;
  final String removeTooltip;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 4, 4),
            child: Row(
              children: [
                const Icon(Icons.location_city, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    place.title(''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                IconButton(
                  tooltip: removeTooltip,
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}