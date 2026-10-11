import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../controllers/weather_controller.dart';
import '../controllers/weather_scope.dart';
import '../services/location_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/current_weather.dart';
import '../widgets/daily_card.dart';
import '../widgets/details_grid.dart';
import '../widgets/error_view.dart';
import '../widgets/header_section.dart';
import '../widgets/hourly_card.dart';
import '../widgets/offline_banner.dart';
import '../widgets/sun_card.dart';
import '../widgets/weather_skeleton.dart';
import 'search_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  WeatherController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = WeatherScope.of(context);
    if (!identical(controller, _controller)) {
      _controller?.removeListener(_onControllerChanged);
      _controller = controller;
      controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  /// Ilovaga qaytganda ma’lumot eskirgan bo‘lsa yangilaydi
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller?.refreshIfStale();
    }
  }

  /// GPS bilan muammo bo‘lsa, pastda xabar chiqaradi
  void _onControllerChanged() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    final issue = controller.takeLocationIssue();
    if (issue == null) return;

    final s = controller.s;
    final message = switch (issue) {
      LocationFailure.denied ||
      LocationFailure.deniedForever =>
      s.locationDenied,
      LocationFailure.serviceDisabled => s.locationDisabled,
      LocationFailure.timeout || LocationFailure.unknown => s.locationFailed,
    };
    // Brauzerda sozlamalarni dasturdan ochib bo‘lmaydi, shuning uchun tugma faqat ilovada
    final canOpenSettings = !kIsWeb &&
        (issue == LocationFailure.deniedForever ||
            issue == LocationFailure.serviceDisabled);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: canOpenSettings
              ? SnackBarAction(
            label: s.settings,
            onPressed: () => controller.openLocationSettings(issue),
          )
              : null,
        ),
      );
  }

  void _openSearch() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
        const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = WeatherScope.of(context);
    final p = c.palette;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: p.bottom,
      endDrawer: AppDrawer(onOpenSearch: _openSearch),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        // Ob-havo o‘zgarsa (kun/tun, yomg‘ir...) fon rangi silliq almashadi
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: p.gradient),
          child: SafeArea(
            child: Column(
              children: [
                HeaderSection(
                  onSearch: _openSearch,
                  onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
                ),
                if (c.refreshing && c.forecast != null)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    color: Colors.white70,
                  )
                else
                  const SizedBox(height: 2),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _body(c),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(WeatherController c) {
    final forecast = c.forecast;

    if (forecast == null) {
      if (c.status == LoadStatus.error) {
        return ErrorView(
          key: const ValueKey('error'),
          onRetry: () {
            c.refresh();
          },
          onSearch: _openSearch,
        );
      }
      return const WeatherSkeleton(key: ValueKey('skeleton'));
    }

    final today = forecast.days.first;
    final hasSun = today.sunrise != null && today.sunset != null;

    return RefreshIndicator(
      key: const ValueKey('content'),
      onRefresh: c.refresh,
      color: kIcon,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          children: [
            if (c.offline)
              OfflineBanner(
                updatedAt: forecast.fetchedAt,
                onRetry: () {
                  c.refresh();
                },
              ),
            CurrentWeather(forecast: forecast),
            const SizedBox(height: 18),
            HourlyCard(forecast: forecast),
            const SizedBox(height: 16),
            DailyCard(forecast: forecast),
            const SizedBox(height: 16),
            DetailsGrid(forecast: forecast),
            if (hasSun) ...[
              const SizedBox(height: 16),
              SunCard(forecast: forecast),
            ],
            const SizedBox(height: 22),
            Text(
              c.s.dataBy,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}