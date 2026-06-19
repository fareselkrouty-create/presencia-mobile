import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'status_badge.dart';

class PointageCard extends StatelessWidget {
  final String date;
  final String? heureEntree;
  final String? heureSortie;
  final PointageStatus status;

  const PointageCard({
    super.key,
    required this.date,
    required this.status,
    this.heureEntree,
    this.heureSortie,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha:0.12),
        ),
      ),
      child: Row(
        children: [
          // Date block
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha:0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(DateTime.parse(date)),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  DateFormat('MMM', 'fr').format(DateTime.parse(date)),
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Heures
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.login, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      heureEntree ?? '--:--',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.logout, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      heureSortie ?? '--:--',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusBadge(status: status),
        ],
      ),
    );
  }
}