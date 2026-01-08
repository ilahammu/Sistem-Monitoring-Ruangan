import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RiwayatController extends GetxController {
  var tabelData = <Map<String, dynamic>>[].obs;
  var currentPage = 0.obs;

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
        tabelData.value = List<Map<String, dynamic>>.from(
          fetched.reversed,
        ); // reversed agar terbaru di atas
      }
    } catch (e) {
      print('Error fetching table data: $e');
    }
  }
}
