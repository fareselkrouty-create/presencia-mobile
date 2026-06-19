import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'configs/app_bindings.dart';
import 'configs/app_routes.dart';
import 'configs/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('fr');
  runApp(const PresenciaApp());
}

class PresenciaApp extends StatelessWidget {
  const PresenciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Presencia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialBinding: AppBindings(),
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
    );
  }
}
