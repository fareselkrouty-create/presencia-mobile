import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import '../controllers/historique_controller.dart';
import '../controllers/profile_controller.dart';
import '../ui/login_screen.dart';
import '../ui/checkin_screen.dart';
import '../ui/main_screen.dart';
import '../ui/historique_screen.dart';
import '../ui/profile_screen.dart';

abstract class Routes {
  Routes._();

  static const login      = '/login';
  static const home       = '/home';
  static const checkin    = '/checkin';
  static const historique = '/historique';
  static const profile    = '/profile';
}

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final pages = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    // GetPage(
    //   name: Routes.home,
    //   page: () => const HomeScreen(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => PointageController());
    //   }),
    // ),
    GetPage(
      name: Routes.home,
      page: () => MainScreen(),       // ← MainScreen au lieu de HomeScreen
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PointageController());
        Get.lazyPut(() => HistoriqueController());
        Get.lazyPut(() => ProfileController());
      }),
    ),
    GetPage(
      name: Routes.checkin,
      page: () => const CheckinScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PointageController());
      }),
    ),
    GetPage(
      name: Routes.historique,
      page: () => const HistoriqueScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HistoriqueController());
      }),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileController());
      }),
    ),
  ];
}