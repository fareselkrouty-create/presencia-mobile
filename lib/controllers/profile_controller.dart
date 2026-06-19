import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../components/app_snakbar.dart';
import '../configs/api_config.dart';

class ProfileController extends GetxController {
  final _api = Get.find<ApiService>();

  final isLoading  = false.obs;
  final isSaving   = false.obs;
  final user       = Rxn<UserModel>();

  // Formulaire profil
  final nomCtrl    = TextEditingController();
  final prenomCtrl = TextEditingController();
  final emailCtrl  = TextEditingController();
  final profileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    ever(user, (u) {
      if (u != null) {
        nomCtrl.text    = u.nom;
        prenomCtrl.text = u.prenom;
        emailCtrl.text  = u.email;
      }
    });
    fetchProfil();
  }

  @override
  void onClose() {
    nomCtrl.dispose();
    prenomCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
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