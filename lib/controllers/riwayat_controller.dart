import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RiwayatController extends GetxController {
  var tabelData = <Map<String, dynamic>>[].obs;
  var currentPage = 0.obs;
  Timer? _timer;

  final dummyData = <Map<String, dynamic>>[
    {
      'created_at': '2026-01-01 08:00',
      'temperature': '27',
      'humidity': '65',
      'status': 'Normal',
    },
    {
      'created_at': '2026-01-01 09:00',
      'temperature': '30',
      'humidity': '70',
      'status': 'Panas',
    },
    {
      'created_at': '2026-01-01 10:00',
      'temperature': '28',
      'humidity': '60',
      'status': 'Normal',
    },
    {
      'created_at': '2026-01-01 11:00',
      'temperature': '32',
      'humidity': '75',
      'status': 'Warning',
    },
    {
      'created_at': '2026-01-01 12:00',
      'temperature': '26',
      'humidity': '55',
      'status': 'Normal',
    },
    {
      'created_at': '2026-01-01 12:00',
      'temperature': '26',
      'humidity': '55',
      'status': 'Normal',
    },
    {
      'created_at': '2026-01-01 12:00',
      'temperature': '26',
      'humidity': '55',
      'status': 'Normal',
    },
  ];

  Future<void> fetchTableData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://wrrd8tmv-3000.asse.devtunnels.ms/api/latest', // endpoint untuk semua data
      );
      if (response.statusCode == 200) {
        final List<dynamic> fetched = response.data is String
            ? json.decode(response.data)
            : response.data;
        // Ambil 50 data terakhir saja
        final last50 = fetched.length > 50
            ? fetched.reversed.take(50).toList().reversed.toList()
            : fetched;
        // Format waktu di controller
        final formatted = last50.map<Map<String, dynamic>>((row) {
          final map = Map<String, dynamic>.from(row);
          String waktu = map['created_at']?.toString() ?? '-';
          if (waktu != '-' && waktu.contains('T')) {
            try {
              DateTime dt = DateTime.parse(waktu.replaceAll('Z', ''));
              dt = dt.toUtc().add(const Duration(hours: 7));
              waktu =
                  '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
                  '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
            } catch (_) {
              waktu = waktu.replaceAll('T', ' ').replaceAll('Z', '');
            }
          }
          map['created_at'] = waktu;
          return map;
        }).toList();
        tabelData.value = List<Map<String, dynamic>>.from(
          formatted.reversed,
        ); // reversed agar terbaru di atas
      } else {}
    } catch (e) {
      print('Error fetching table data: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTableData();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchTableData();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
