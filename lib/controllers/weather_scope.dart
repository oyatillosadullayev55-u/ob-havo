import 'package:flutter/widgets.dart';

import 'weather_controller.dart';

/// Controller'ni butun ilovaga yetkazadi. O‘zgarsa, uni ishlatgan vidjetlar
/// avtomatik qayta chiziladi.
class WeatherScope extends InheritedNotifier<WeatherController> {
  const WeatherScope({
    super.key,
    required WeatherController controller,
    required super.child,
  }) : super(notifier: controller);

  /// O‘zgarishlarni kuzatadi (build ichida ishlating)
  static WeatherController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WeatherScope>();
    assert(scope != null, 'WeatherScope topilmadi');
    return scope!.notifier!;
  }

  /// Faqat o‘qiydi, kuzatmaydi (tugma bosilganda ishlating)
  static WeatherController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<WeatherScope>();
    assert(scope != null, 'WeatherScope topilmadi');
    return scope!.notifier!;
  }
}