import 'constants.dart';

class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return AppConstants.champRequis;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppConstants.champRequis;
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) return AppConstants.emailInvalide;
    return null;
  }

  static String? matricule(String? value) {
    if (value == null || value.trim().isEmpty) return AppConstants.champRequis;
    if (value.trim().length < 3) return 'Matricule trop court.';
    return null;
  }

  static String? motDePasse(String? value) {
    if (value == null || value.isEmpty) return AppConstants.champRequis;
    if (value.length < 6) return 'Minimum 6 caractères.';
    return null;
  }

  // Combiner plusieurs validators
  static String? Function(String?) compose(
      List<String? Function(String?)> validators,
      ) =>
          (value) {
        for (final v in validators) {
          final result = v(value);
          if (result != null) return result;
        }
        return null;
      };
}
