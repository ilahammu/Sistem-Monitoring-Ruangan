import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class HomeController extends GetxController {
  var data = <String, dynamic>{'suhu': 'Meledak', 'kelembapan': 'Meledak'}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://wrrd8tmv-3000.asse.devtunnels.ms/api/latest',
      );
      if (response.statusCode == 200) {
        final fetchedData = response.data is String
            ? json.decode(response.data)
            : response.data;
        data['suhu'] = '${fetchedData['temperature']}°C';
        data['kelembapan'] = '${fetchedData['humidity']}%';
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
