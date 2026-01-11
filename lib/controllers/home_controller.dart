import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

class HomeController extends GetxController {
  var data = <String, dynamic>{'suhu': 'Meledak', 'kelembapan': 'Meledak'}.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetchData();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void fetchData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://wrrd8tmv-3000.asse.devtunnels.ms/api/latest',
      );
      if (response.statusCode == 200) {
        final rawData = response.data is String
            ? json.decode(response.data)
            : response.data;
        final latest = (rawData is List && rawData.isNotEmpty)
            ? rawData.last
            : rawData;
        data['suhu'] = '${latest['temperature']}°C';
        data['kelembapan'] = '${latest['humidity']}%';
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
