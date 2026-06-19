import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../components/custom_button.dart';
import '../components/custom_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final theme      = Theme.of(context);

    final matriculeCtrl = TextEditingController();
    final passwordCtrl  = TextEditingController();
    final formKey       = GlobalKey<FormState>();
    final obscure       = true.obs;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Logo / titre
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Bienvenue',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Connectez-vous pour pointer',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 40),

                // Matricule
                CustomInput(
                  label: 'Matricule',
                  hint: 'Ex : EMP-001',
                  controller: matriculeCtrl,
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 20),

                // Mot de passe
                Obx(() => CustomInput(
                  label: 'Mot de passe',
                  hint: '••••••••',
                  controller: passwordCtrl,
                  obscureText: obscure.value,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Champ requis' : null,
                  suffixWidget: GestureDetector(
                    onTap: () => obscure.toggle(),
                    child: Icon(
                      obscure.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                )),
                const SizedBox(height: 36),

                // Bouton connexion
                Obx(() => CustomButton(
                  label: 'Se connecter',
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.login(
                        matriculeCtrl.text.trim(),
                        passwordCtrl.text.trim(),
                      );
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}