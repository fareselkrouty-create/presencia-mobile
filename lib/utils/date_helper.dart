import 'package:intl/intl.dart';
import 'constants.dart';

class DateHelper {
  DateHelper._();

  // "2024-05-20" → "20/05/2024"
  static String formatAffichage(String date) {
    try {
      final d = DateTime.parse(date);
      return DateFormat(AppConstants.dateDisplayFormat).format(d);
    } catch (_) {
      return date;
    }
  }

  // "08:30" → DateTime avec la date du jour
  static DateTime heureVersDateTime(String heure) {
    final parts = heure.split(':');
    final now   = DateTime.now();
    return DateTime(
      now.year, now.month, now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // DateTime → "08:30"
  static String dateTimeVersHeure(DateTime dt) =>
      DateFormat(AppConstants.heureFormat).format(dt);

  // DateTime → "2024-05-20"
  static String dateTimeVersString(DateTime dt) =>
      DateFormat(AppConstants.dateFormat).format(dt);

  // "lundi 20 mai 2024"
  static String formatLong(String date) {
    try {
      final d = DateTime.parse(date);
      return DateFormat('EEEE d MMMM yyyy', 'fr').format(d);
    } catch (_) {
      return date;
    }
  }

  // Durée entre deux heures → "8h30"
  static String dureeTravail(String entree, String sortie) {
    try {
      final e = heureVersDateTime(entree);
      final s = heureVersDateTime(sortie);
      final diff = s.difference(e);
      final h = diff.inHours;
      final m = diff.inMinutes.remainder(60);
      return '${h}h${m.toString().padLeft(2, '0')}';
    } catch (_) {
      return '--h--';
    }
  }

  // Vérifie si une date est aujourd'hui
  static bool estAujourdhui(String date) {
    try {
      final d   = DateTime.parse(date);
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    } catch (_) {
      return false;
    }
  }

  // Nom du mois en français
  static String nomMois(DateTime date) =>
      DateFormat('MMMM yyyy', 'fr').format(date);
}