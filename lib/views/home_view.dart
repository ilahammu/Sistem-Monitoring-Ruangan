// Widget animasi WARNING fade in/out penuh

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView {
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
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/riwayat');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 170, 145, 145),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(129, 88, 77, 120),
                                  Color.fromARGB(255, 96, 82, 148),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Text(
                              'Chect Data Table ->',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 254, 254),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Obx(() => _buildIndicators()),
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

    Color greenColor, yellowColor, redColor;

    if ((suhu < 20 || suhu > 35) || (kelembapan < 30 || kelembapan > 70)) {
      // LAMPU MERAH NYALA
      redColor = Colors.red;
      yellowColor = Colors.yellow.withOpacity(0.3);
      greenColor = const Color.fromARGB(255, 38, 237, 45).withOpacity(0.3);
    } else if ((suhu > 30 && suhu <= 35) ||
        (kelembapan >= 60 && kelembapan <= 70)) {
      // LAMPU KUNING NYALA
      redColor = Colors.red.withOpacity(0.3);
      yellowColor = Colors.yellow;
      greenColor = Colors.green.withOpacity(0.3);
    } else if ((suhu > 23 && suhu < 30) ||
        (kelembapan >= 40 && kelembapan < 60)) {
      // LAMPU HIJAU NYALA
      redColor = Colors.red.withOpacity(0.3);
      yellowColor = Colors.yellow.withOpacity(0.3);
      greenColor = const Color.fromARGB(255, 0, 255, 8);
    } else {
      redColor = Colors.red.withOpacity(0.3);
      yellowColor = Colors.yellow.withOpacity(0.3);
      greenColor = Colors.green.withOpacity(0.3);
    }

    return Column(
      children: [
        _warningBanner(suhu > 31 || kelembapan > 75),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _indicator(30, greenColor, 'Normal'),
            _indicator(30, yellowColor, 'Caution'),
            _indicator(30, redColor, 'Warning'),
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

  Widget _warningBanner(bool show) {
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      child: show
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(154, 244, 67, 54).withValues(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'WARNING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  // Tabel riwayat data sensor dengan pagination
}
