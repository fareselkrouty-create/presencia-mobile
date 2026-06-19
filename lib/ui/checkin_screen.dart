import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import '../components/custom_button.dart';

class CheckinScreen extends StatelessWidget {
  const CheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PointageController>();
    final theme      = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'Pointage',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Votre position GPS sera enregistrée',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 50),

              // Bouton circulaire principal
              GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : () => _confirmerPointage(context, controller),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isCheckedIn.value
                        ? const Color(0xFFC62828)
                        : theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (controller.isCheckedIn.value
                            ? const Color(0xFFC62828)
                            : theme.colorScheme.primary)
                            .withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3)
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.isCheckedIn.value
                            ? Icons.logout
                            : Icons.login,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.isCheckedIn.value
                            ? 'Check-out'
                            : 'Check-in',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Heures du jour
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoHeure(
                    label: 'Entrée',
                    heure: controller.heureEntree.value,
                    icon: Icons.login,
                    color: const Color(0xFF2E7D32),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: theme.colorScheme.outline.withOpacity(0.15),
                  ),
                  _InfoHeure(
                    label: 'Sortie',
                    heure: controller.heureSortie.value,
                    icon: Icons.logout,
                    color: const Color(0xFFC62828),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }

  void _confirmerPointage(
      BuildContext context, PointageController controller) {
    final isCheckIn = !controller.isCheckedIn.value;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isCheckIn ? 'Confirmer l\'entrée' : 'Confirmer la sortie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Votre position GPS sera enregistrée avec ce pointage.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (isCheckIn) {
                controller.checkIn();
              } else {
                controller.checkOut();
              }
            },
            child: Text(isCheckIn ? 'Pointer l\'entrée' : 'Pointer la sortie'),
          ),
        ],
      ),
    );
  }
}

class _InfoHeure extends StatelessWidget {
  final String label;
  final String heure;
  final IconData icon;
  final Color color;

  const _InfoHeure({
    required this.label,
    required this.heure,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          heure,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}