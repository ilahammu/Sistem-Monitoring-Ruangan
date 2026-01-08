import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:tubes_prd/bindings/home_bindings.dart';
import 'package:tubes_prd/bindings/riwayat_bindings.dart';

import 'package:tubes_prd/views/home_view.dart';
import 'package:tubes_prd/views/riwayat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(name: _Paths.home, page: () => HomeView(), binding: HomeBindings()),
    GetPage(
      name: _Paths.riwayat,
      page: () => RiwayatView(),
      binding: RiwayatBindings(),
    ),
  ];
}
