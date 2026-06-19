import 'package:get/get.dart';
import '../models/pointage_model.dart';
import '../services/api_service.dart';
import '../components/app_snackbar.dart';
import '../config/api_config.dart';

class HistoriqueController extends GetxController {
  final _api = Get.find<ApiService>();

  final isLoading    = false.obs;
  final pointages    = <PointageModel>[].obs;
  final filteredList = <PointageModel>[].obs;

  // Filtres
  final selectedMonth = DateTime.now().obs;
  final searchQuery   = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistorique();
    // Réappliquer le filtre dès qu'une valeur change
    ever(pointages,    (_) => _applyFilters());
    ever(selectedMonth,(_) => fetchHistorique());
    debounce(searchQuery, (_) => _applyFilters(),
        time: const Duration(milliseconds: 300));
  }

  Future<void> fetchHistorique() async {
    try {
      isLoading(true);
      final month = selectedMonth.value;
      final data = await _api.get(
        ApiConfig.historique,
        queryParams: {
          'mois': month.month.toString(),
          'annee': month.year.toString(),
        },
      );
      final list = (data as List)
          .map((e) => PointageModel.fromJson(e))
          .toList();
      pointages.assignAll(list);
    } catch (e) {
      AppSnackbar.show(message: e.toString(), type: SnackType.error);
    } finally {
      isLoading(false);
    }
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();
    filteredList.assignAll(
      pointages.where((p) {
        if (query.isEmpty) return true;
        return p.date.toLowerCase().contains(query);
      }).toList(),
    );
  }

  void setMonth(DateTime date) => selectedMonth(date);

  void setSearch(String value) => searchQuery(value);

  // Statistiques calculées pour le dashboard du mois
  int get totalPresents => pointages
      .where((p) => p.statut == 'PRESENT')
      .length;

  int get totalAbsents => pointages
      .where((p) => p.statut == 'ABSENT')
      .length;

  int get totalRetards => pointages
      .where((p) => p.statut == 'RETARD')
      .length;
}