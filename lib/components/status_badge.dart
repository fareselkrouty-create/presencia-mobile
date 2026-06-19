import 'package:flutter/material.dart';

enum PointageStatus { present, absent, retard, enConge }

class StatusBadge extends StatelessWidget {
  final PointageStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Map<PointageStatus, (String, Color, Color)> config = {
      PointageStatus.present: ('Présent', const Color(0xFFE6F4EA), const Color(0xFF2E7D32)),
      PointageStatus.absent:  ('Absent',  const Color(0xFFFFEBEE), const Color(0xFFC62828)),
      PointageStatus.retard:  ('Retard',  const Color(0xFFFFF8E1), const Color(0xFFF57F17)),
      PointageStatus.enConge: ('En congé',const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
    };

    final (label, bg, fg) = config[status]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}