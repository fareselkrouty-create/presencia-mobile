import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../components/app_snackbar.dart';
import '../config/api_config.dart';

class ProfileController extends GetxController {
  final _api     = Get.find<ApiService>();
  final _auth    = Get.find<AuthService>();
  final _storage = Get.find<StorageService>();

  final isLoading  = false.obs;
  final isSaving   = false.obs;
  final user       = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchProfil();
  }

  Future<void> fetchProfil() async {
    try {
      isLoading(true);
      final data = await _api.get(ApiConfig.profil);
      user(UserModel.fromJson(data));
    } catch (e) {
      AppSnackbar.show(message: e.toString(), type: SnackType.error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfil({
    required String nom,
    required String prenom,
    required String email,
  }) async {
    try {
      isSaving(true);
      final data = await _api.put(ApiConfig.updateProfil, {
        'nom': nom,
        'prenom': prenom,
        'email': email,
      });
      user(UserModel.fromJson(data));
      AppSnackbar.show(
        message: 'Profil mis à jour avec succès',
        type: SnackType.success,
      );
    } catch (e) {
      AppSnackbar.show(message: e.toString(), type: SnackType.error);
    } finally {
      isSaving(false);
    }
  }

  String get nomComplet {
    final u = user.value;
    if (u == null) return '';
    return '${u.prenom} ${u.nom}';
  }

  String get initialesAvatar {
    final u = user.value;
    if (u == null) return '?';
    return '${u.prenom[0]}${u.nom[0]}'.toUpperCase();
  }
}