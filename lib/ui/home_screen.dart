import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/pointage_controller.dart';
import '../controllers/historique_controller.dart';
import '../controllers/auth_controller.dart';
import '../components/status_badge.dart';
import '../components/pointage_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pointageCtrl   = Get.find<PointageController>();
    final historiqueCtrl = Get.find<HistoriqueController>();
    final authCtrl       = Get.find<AuthController>();
    final theme          = Theme.of(context);
    final now            = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await pointageCtrl.fetchStatutAujourdhui();
            await historiqueCtrl.fetchHistorique();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final user = authCtrl.currentUser.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour, ${user?.prenom ?? ''} 👋',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            DateFormat('EEEE d MMMM', 'fr').format(now),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha:0.5),
                            ),
                          ),
                        ],
                      );
                    }),
                    Obx(() {
                      final user = authCtrl.currentUser.value;
                      return CircleAvatar(
                        radius: 22,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha:0.12),
                        child: Text(
                          user != null
                              ? '${user.prenom[0]}${user.nom[0]}'.toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),

                // Carte statut aujourd'hui
                Obx(() => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aujourd'hui",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _HeureChip(
                            icon: Icons.login,
                            label: 'Entrée',
                            heure: pointageCtrl.heureEntree.value,
                          ),
                          const SizedBox(width: 16),
                          _HeureChip(
                            icon: Icons.logout,
                            label: 'Sortie',
                            heure: pointageCtrl.heureSortie.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      pointageCtrl.pointageAujourdhui.value != null
                          ? StatusBadge(
                        status: _mapStatut(
                          pointageCtrl.pointageAujourdhui.value!.statut,
                        ),
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                )),
                const SizedBox(height: 28),

                // Stats du mois
                Text(
                  'Ce mois-ci',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => Row(
                  children: [
                    _StatCard(
                      label: 'Présences',
                      value: historiqueCtrl.totalPresents.toString(),
                      color: const Color(0xFF2E7D32),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'Absences',
                      value: historiqueCtrl.totalAbsents.toString(),
                      color: const Color(0xFFC62828),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'Retards',
                      value: historiqueCtrl.totalRetards.toString(),
                      color: const Color(0xFFF57F17),
                    ),
                  ],
                )),
                const SizedBox(height: 28),

                // Derniers pointages
                Text(
                  'Derniers pointages',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final list = historiqueCtrl.pointages.take(5).toList();
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun pointage ce mois-ci',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha:0.4),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: list
                        .map((p) => PointageCard(
                      date:        p.date,
                      heureEntree: p.heureEntree,
                      heureSortie: p.heureSortie,
                      status:      _mapStatut(p.statut),
                    ))
                        .toList(),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PointageStatus _mapStatut(String statut) => switch (statut) {
    'PRESENT'  => PointageStatus.present,
    'ABSENT'   => PointageStatus.absent,
    'RETARD'   => PointageStatus.retard,
    'EN_CONGE' => PointageStatus.enConge,
    _          => PointageStatus.absent,
  };
}

class _HeureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String heure;

  const _HeureChip({
    required this.icon,
    required this.label,
    required this.heure,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 11)),
            Text(heure,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha:0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color.withValues(alpha:0.8)),
            ),
          ],
        ),
      ),
    );
  }
}