// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature & Humidity'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(144, 90, 27, 185),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 127, 35, 203),
              const Color.fromARGB(255, 113, 88, 140),
              const Color.fromARGB(210, 119, 98, 143),
            ],
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Jam real-time di kiri
                      StreamBuilder<DateTime>(
                        stream: Stream.periodic(
                          Duration(seconds: 1),
                          (_) => DateTime.now(),
                        ),
                        builder: (context, snapshot) {
                          final now = snapshot.data ?? DateTime.now();
                          final formattedTime =
                              "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                          return Text(
                            formattedTime,
                            style: GoogleFonts.kiteOne(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      // "Data Sensor" di kanan
                      Text(
                        "Data Sensor",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _nampilin_data(
                        title: 'Temperature',
                        icon: Icons.thermostat,
                        value: Obx(
                          () => Text(
                            '${controller.data['suhu']}',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        color: const Color.fromARGB(33, 159, 184, 204),
                      ),
                      SizedBox(height: 8),
                      _nampilin_data(
                        title: 'Humidity',
                        icon: Icons.water_drop,
                        value: Obx(
                          () => Text(
                            '${controller.data['kelembapan']}',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        color: const Color.fromARGB(33, 159, 184, 204),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _tampilTabel(),
                ],
              ),
              SizedBox(height: 16),
              _buildIndicators(),
            ],
          ),
        ),
      ),
    );
  }

  // Indikator status suhu dan kelembapan
  Widget _buildIndicators() {
    final suhu =
        double.tryParse(
          controller.data['suhu'].toString().replaceAll('°C', ''),
        ) ??
        0.0;
    final kelembapan =
        double.tryParse(
          controller.data['kelembapan'].toString().replaceAll('%', ''),
        ) ??
        0.0;

    Color greenColor = (suhu < 28 && kelembapan < 50)
        ? Colors.green
        : Colors.green.withOpacity(0.3);
    Color yellowColor =
        ((suhu >= 28.1 && suhu <= 31) || (kelembapan >= 50 && kelembapan <= 74))
        ? Colors.yellow
        : Colors.yellow.withOpacity(0.3);
    Color redColor = (suhu > 31.1 || kelembapan > 75)
        ? Colors.red
        : Colors.red.withOpacity(0.3);

    return Column(
      children: [
        if (suhu > 31.1 || kelembapan > 75)
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'WARNING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _indicator(30, greenColor, 'Low'),
            _indicator(30, yellowColor, 'Medium'),
            _indicator(30, redColor, 'High'),
          ],
        ),
      ],
    );
  }

  Widget _indicator(double size, Color color, String label) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.kiteOne(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }

  Widget _nampilin_data({
    required String title,
    required IconData icon,
    required Widget value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.zero,
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color.fromARGB(255, 105, 78, 109),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: GoogleFonts.eczar(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Icon(icon, size: 80, color: Colors.white),
          SizedBox(height: 8),
          value,
        ],
      ),
    );
  }

  // Tabel riwayat data sensor dengan pagination
  Widget _tampilTabel() {
    final controller = Get.find<HomeController>();
    return Obx(() {
      final data = controller.tabelData;
      final page = controller.currentPage.value;
      final pageSize = 5;
      final totalPage = (data.length / pageSize).ceil();
      final start = page * pageSize;
      final end = (start + pageSize) > data.length
          ? data.length
          : (start + pageSize);
      final pageData = data.sublist(start, end);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Riwayat Data Sensor',
            style: GoogleFonts.kiteOne(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: const Color.fromARGB(255, 105, 78, 109),
                width: 1.5,
              ),
              color: const Color.fromARGB(255, 185, 41, 41).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color.fromARGB(14, 148, 118, 200).withOpacity(0.2),
              ),
              columns: const [
                DataColumn(
                  label: Text('Waktu', style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Suhu', style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text(
                    'Kelembapan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DataColumn(
                  label: Text('Status', style: TextStyle(color: Colors.white)),
                ),
              ],
              rows: pageData.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        row['created_at'] ?? '-',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${row['temperature']}°C',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${row['humidity']}%',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        row['status'] ?? '-',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          if (totalPage > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: page > 0
                      ? () => controller.currentPage.value--
                      : null,
                ),
                Text(
                  '${page + 1} / $totalPage',
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: page < totalPage - 1
                      ? () => controller.currentPage.value++
                      : null,
                ),
              ],
            ),
        ],
      );
    });
  }
}
