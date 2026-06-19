import 'pointage_model.dart';

class HistoriqueModel {
  final int mois;
  final int annee;
  final List<PointageModel> pointages;
  final int totalJours;
  final int joursPresent;
  final int joursAbsent;
  final int joursRetard;
  final int joursConge;

  HistoriqueModel({
    required this.mois,
    required this.annee,
    required this.pointages,
    required this.totalJours,
    required this.joursPresent,
    required this.joursAbsent,
    required this.joursRetard,
    required this.joursConge,
  });

  factory HistoriqueModel.fromJson(Map<String, dynamic> json) => HistoriqueModel(
    mois:         json['mois'],
    annee:        json['annee'],
    pointages:    (json['pointages'] as List)
        .map((e) => PointageModel.fromJson(e))
        .toList(),
    totalJours:   json['totalJours']   ?? 0,
    joursPresent: json['joursPresent'] ?? 0,
    joursAbsent:  json['joursAbsent']  ?? 0,
    joursRetard:  json['joursRetard']  ?? 0,
    joursConge:   json['joursConge']   ?? 0,
  );

  // Taux de présence en pourcentage
  double get tauxPresence {
    if (totalJours == 0) return 0;
    return (joursPresent / totalJours) * 100;
  }
}