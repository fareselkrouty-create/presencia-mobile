import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

// Enregistre les services globaux au démarrage de l'app
// Les controllers sont injectés par chaque GetPage (voir app_routes.dart)

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);
    Get.put(ApiService(),     permanent: true);
    Get.put(AuthService(),    permanent: true);
  }
}