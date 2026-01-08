import 'package:get/get.dart';
import 'package:tubes_prd/controllers/riwayat_controller.dart';

class RiwayatBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatController>(() => RiwayatController());
  }
}
