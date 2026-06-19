import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/historique_controller.dart';
import '../components/pointage_card.dart';
import '../components/status_badge.dart';

class HistoriqueScreen extends StatelessWidget {
  const HistoriqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoriqueController>();
    final theme      = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Historique',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sélecteur de mois
                  Obx(() => GestureDetector(
                    onTap: () => _choisirMois(context, controller),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha:0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                          theme.colorScheme.outline.withValues(alpha:0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              size: 18),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMMM yyyy', 'fr')
                                .format(controller.selectedMonth.value),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),

                  // Stats rapides
                  Obx(() => Row(
                    children: [
                      _MiniStat(
                          label: 'Présents',
                          value: controller.totalPresents,
                          color: const Color(0xFF2E7D32)),
                      const SizedBox(width: 8),
                      _MiniStat(
                          label: 'Absents',
                          value: controller.totalAbsents,
                          color: const Color(0xFFC62828)),
                      const SizedBox(width: 8),
                      _MiniStat(
                          label: 'Retards',
                          value: controller.totalRetards,
                          color: const Color(0xFFF57F17)),
                    ],
                  )),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Liste
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurface.withValues(alpha:0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'Aucun pointage ce mois-ci',
                          style: TextStyle(
                            color:
                            theme.colorScheme.onSurface.withValues(alpha:0.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (_, i) {
                    final p = controller.filteredList[i];
                    return PointageCard(
                      date:        p.date,
                      heureEntree: p.heureEntree,
                      heureSortie: p.heureSortie,
                      status:      _mapStatut(p.statut),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _choisirMois(
      BuildContext context, HistoriqueController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedMonth.value,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) controller.setMonth(picked);
  }

  PointageStatus _mapStatut(String statut) => switch (statut) {
    'PRESENT'  => PointageStatus.present,
    'ABSENT'   => PointageStatus.absent,
    'RETARD'   => PointageStatus.retard,
    'EN_CONGE' => PointageStatus.enConge,
    _          => PointageStatus.absent,
  };
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
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