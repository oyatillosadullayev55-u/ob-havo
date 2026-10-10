import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../controllers/weather_controller.dart';
import '../controllers/weather_scope.dart';
import '../data/popular_cities.dart';
import '../models/weather_models.dart';

/// Shahar qidirish: nom yozing, ro‘yxatdan tanlang yoki yulduzcha bilan saqlang.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  Timer? _debounce;

  List<GeoPlace> _results = const [];
  bool _loading = false;
  bool _failed = false;
  String _query = '';
  int _searchId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    setState(() {
      _query = query;
      _failed = false;
      _loading = query.length >= 2;
      if (query.length < 2) _results = const [];
    });
    if (query.length < 2) return;
    // Har harfda emas, yozish to‘xtagach 0.4 soniyadan keyin qidiradi
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    final id = ++_searchId;
    final controller = WeatherScope.read(context);
    try {
      final found = await controller.search(query);
      if (!mounted || id != _searchId) return;
      setState(() {
        _results = found;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || id != _searchId) return;
      setState(() {
        _results = const [];
        _loading = false;
        _failed = true;
      });
    }
  }

  void _clear() {
    _textController.clear();
    _onChanged('');
  }

  void _pick(GeoPlace place) {
    final controller = WeatherScope.read(context);
    Navigator.of(context).pop();
    controller.selectPlace(place);
  }

  void _useMyLocation() {
    final controller = WeatherScope.read(context);
    Navigator.of(context).pop();
    controller.useMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final p = c.palette;

    return Scaffold(
      backgroundColor: p.bottom,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: p.gradient),
          child: SafeArea(
            child: Column(
              children: [
                _topBar(c),
                Expanded(child: _body(c)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(WeatherController c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: kIcon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: _onChanged,
                      style: const TextStyle(color: kText, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: c.s.searchHint,
                        hintStyle: const TextStyle(color: Color(0xFF8A9BAE)),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: _clear,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF8A9BAE),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(WeatherController c) {
    final s = c.s;

    if (_query.length < 2) return _suggestions(c);
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_failed) return _message(s.searchFailed);
    if (_results.isEmpty) return _message(s.noResults);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final place = _results[index];
        final favorite = c.isFavorite(place);
        return _PlaceTile(
          title: place.name,
          subtitle: place.subtitle,
          favorite: favorite,
          tooltip: favorite ? s.removeCity : s.saveCity,
          onTap: () => _pick(place),
          onToggleFavorite: () => c.toggleFavorite(place),
        );
      },
    );
  }

  Widget _message(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _suggestions(WeatherController c) {
    final s = c.s;
    final popular = popularCities(c.language);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _ActionTile(
          icon: Icons.my_location,
          label: s.myLocation,
          onTap: _useMyLocation,
        ),
        if (c.favorites.isNotEmpty) ...[
          const SizedBox(height: 20),
          _Heading(s.savedCities),
          for (final place in c.favorites)
            _PlaceTile(
              title: place.name,
              subtitle: place.subtitle,
              favorite: true,
              tooltip: s.removeCity,
              onTap: () => _pick(place),
              onToggleFavorite: () => c.toggleFavorite(place),
            ),
        ],
        const SizedBox(height: 20),
        _Heading(s.popularCities),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final place in popular)
              _CityChip(label: place.name, onTap: () => _pick(place)),
          ],
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

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

class _ActionTile extends StatelessWidget {
  const _ActionTile({
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
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  const _PlaceTile({
    required this.title,
    required this.subtitle,
    required this.favorite,
    required this.tooltip,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final String title;
  final String subtitle;
  final bool favorite;
  final String tooltip;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: tooltip,
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    favorite ? Icons.star : Icons.star_border,
                    color: favorite ? kSun : Colors.white70,
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

class _CityChip extends StatelessWidget {
  const _CityChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}