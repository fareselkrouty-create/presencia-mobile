class PointageModel {
  final int id;
  final String date;
  final String? heureEntree;
  final String? heureSortie;
  final String statut;        // PRESENT | ABSENT | RETARD | EN_CONGE
  final double? latitude;
  final double? longitude;
  final String? remarque;

  PointageModel({
    required this.id,
    required this.date,
    required this.statut,
    this.heureEntree,
    this.heureSortie,
    this.latitude,
    this.longitude,
    this.remarque,
  });

  factory PointageModel.fromJson(Map<String, dynamic> json) => PointageModel(
    id:          json['id'],
    date:        json['date'],
    heureEntree: json['heureEntree'],
    heureSortie: json['heureSortie'],
    statut:      json['statut'],
    latitude:    json['latitude'] != null
        ? (json['latitude'] as num).toDouble()
        : null,
    longitude:   json['longitude'] != null
        ? (json['longitude'] as num).toDouble()
        : null,
    remarque:    json['remarque'],
  );

  Map<String, dynamic> toJson() => {
    'id':          id,
    'date':        date,
    'heureEntree': heureEntree,
    'heureSortie': heureSortie,
    'statut':      statut,
    'latitude':    latitude,
    'longitude':   longitude,
    'remarque':    remarque,
  };

  // Durée travaillée calculée côté client
  Duration? get dureeTravail {
    if (heureEntree == null || heureSortie == null) return null;
    final entree  = _parseHeure(heureEntree!);
    final sortie  = _parseHeure(heureSortie!);
    return sortie.difference(entree);
  }

  String get dureeTravailFormatee {
    final d = dureeTravail;
    if (d == null) return '--h--';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '${h}h${m.toString().padLeft(2, '0')}';
  }

  DateTime _parseHeure(String heure) {
    final parts = heure.split(':');
    final now   = DateTime.now();
    return DateTime(now.year, now.month, now.day,
        int.parse(parts[0]), int.parse(parts[1]));
  }
}