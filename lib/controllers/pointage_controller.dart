import 'package:get/get.dart';
import '../models/pointage_model.dart';
import '../services/api_service.dart';
import '../components/app_snakbar.dart';
import '../configs/api_config.dart';

class PointageController extends GetxController {
  final _api = Get.find<ApiService>();

  final isLoading       = false.obs;
  final isCheckedIn     = false.obs;
  final pointageAujourdhui = Rxn<PointageModel>();
  final heureEntree     = ''.obs;
  final heureSortie     = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatutAujourdhui();
  }

  Future<void> fetchStatutAujourdhui() async {
    try {
      isLoading(true);
      final data = await _api.get('${ApiConfig.pointageById}/today');
      final pointage = PointageModel.fromJson(data);
      pointageAujourdhui(pointage);
      isCheckedIn(pointage.heureSortie == null && pointage.heureEntree != null);
      heureEntree(pointage.heureEntree ?? '--:--');
      heureSortie(pointage.heureSortie ?? '--:--');
    } catch (e) {
      // Pas encore pointé aujourd'hui — état initial normal
      isCheckedIn(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkIn() async {
    try {
      isLoading(true);
      final data = await _api.post(ApiConfig.checkIn, {});
      final pointage = PointageModel.fromJson(data);
      pointageAujourdhui(pointage);
      isCheckedIn(true);
      heureEntree(pointage.heureEntree ?? '--:--');
      AppSnackbar.show(
        message: 'Entrée enregistrée à ${pointage.heureEntree}',
        type: SnackType.success,
      );
    } catch (e) {
      AppSnackbar.show(message: e.toString(), type: SnackType.error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkOut() async {
    try {
      isLoading(true);
      final data = await _api.post(ApiConfig.checkOut, {});
      final pointage = PointageModel.fromJson(data);
      pointageAujourdhui(pointage);
      isCheckedIn(false);
      heureSortie(pointage.heureSortie ?? '--:--');
      AppSnackbar.show(
        message: 'Sortie enregistrée à ${pointage.heureSortie}',
        type: SnackType.success,
      );
    } catch (e) {
      AppSnackbar.show(message: e.toString(), type: SnackType.error);
    } finally {
      isLoading(false);
    }
  }
}