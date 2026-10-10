import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'controllers/weather_controller.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final storage = await StorageService.create();
  final controller = WeatherController(storage)..loadLocal();

  runApp(WeatherApp(controller: controller));

  // Ilova ochilib bo‘lgach, internetdan yangi prognozni yuklaydi
  controller.start();
}