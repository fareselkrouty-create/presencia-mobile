import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../configs/app_routes.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../components/app_snakbar.dart';

class AuthController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _storage = Get.find<StorageService>();

  final isLoading = false.obs;
  final currentUser = Rxn<UserModel>();

  // Formulaire login
  final matriculeCtrl = TextEditingController();
  final passwordCtrl  = TextEditingController();
  final loginFormKey  = GlobalKey<FormState>();
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  @override
  void onClose() {
    matriculeCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void _checkSession() {
    final token = _storage.getToken();
    if (token != null) {
      Get.offAllNamed(Routes.home);
    }
  }

  Future<void> login(String matricule, String password) async {
    if (matricule.isEmpty || password.isEmpty) {
      AppSnackbar.show(message: 'Veuillez remplir tous les champs.', type: SnackType.warning);
      return;
    }

    try {
      isLoading(true);
      final user = await _authService.login(matricule, password);
      currentUser(user);
      Get.offAllNamed(Routes.home);
    } catch (e) {
      AppSnackbar.show(message: e.toString(), type: SnackType.error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      currentUser(null);
      Get.offAllNamed(Routes.login);
    }
  }
}