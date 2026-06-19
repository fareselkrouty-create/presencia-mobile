class AppConstants {
  AppConstants._();

  // Formats de date
  static const String dateFormat        = 'yyyy-MM-dd';
  static const String dateDisplayFormat = 'dd/MM/yyyy';
  static const String heureFormat       = 'HH:mm';
  static const String dateHeureFormat   = 'dd/MM/yyyy HH:mm';

  // Statuts pointage (miroir du backend)
  static const String statutPresent = 'PRESENT';
  static const String statutAbsent  = 'ABSENT';
  static const String statutRetard  = 'RETARD';
  static const String statutConge   = 'EN_CONGE';

  // Rôles
  static const String roleEmploye = 'EMPLOYE';
  static const String roleAdmin   = 'ADMIN';

  // Messages génériques
  static const String erreurReseau    = 'Erreur réseau. Vérifiez votre connexion.';
  static const String erreurServeur   = 'Erreur serveur. Réessayez plus tard.';
  static const String champRequis     = 'Ce champ est requis.';
  static const String emailInvalide   = 'Adresse email invalide.';
}