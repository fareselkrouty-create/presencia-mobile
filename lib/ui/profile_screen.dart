import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';
import '../components/custom_button.dart';
import '../components/custom_input.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final authCtrl   = Get.find<AuthController>();
    final theme      = Theme.of(context);

    final nomCtrl    = TextEditingController();
    final prenomCtrl = TextEditingController();
    final emailCtrl  = TextEditingController();
    final formKey    = GlobalKey<FormState>();

    // Préremplir les champs dès que le user est chargé
    ever(controller.user, (user) {
      if (user != null) {
        nomCtrl.text    = user.nom;
        prenomCtrl.text = user.prenom;
        emailCtrl.text  = user.email;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = controller.user.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Mon profil',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Avatar
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.12),
                          child: Text(
                            controller.initialesAvatar,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.nomComplet,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user?.matricule ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Infos non modifiables
                  _InfoRow(
                    icon: Icons.work_outline,
                    label: 'Poste',
                    value: user?.poste ?? '-',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.business_outlined,
                    label: 'Département',
                    value: user?.departement ?? '-',
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'Modifier mes informations',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),

                  CustomInput(
                    label: 'Prénom',
                    controller: prenomCtrl,
                    prefixIcon: Icons.person_outline,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    label: 'Nom',
                    controller: nomCtrl,
                    prefixIcon: Icons.person_outline,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    label: 'Email',
                    controller: emailCtrl,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    v != null && v.contains('@') ? null : 'Email invalide',
                  ),
                  const SizedBox(height: 28),

                  Obx(() => CustomButton(
                    label: 'Enregistrer',
                    isLoading: controller.isSaving.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.updateProfil(
                          nom:    nomCtrl.text.trim(),
                          prenom: prenomCtrl.text.trim(),
                          email:  emailCtrl.text.trim(),
                        );
                      }
                    },
                  )),
                  const SizedBox(height: 16),

                  CustomButton(
                    label: 'Se déconnecter',
                    type: ButtonType.outline,
                    icon: Icons.logout,
                    onPressed: () => authCtrl.logout(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.5)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}