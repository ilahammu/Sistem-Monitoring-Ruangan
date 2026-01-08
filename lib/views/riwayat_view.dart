import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_prd/controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data senosr History'),
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
          child: Column(children: [_tampilTabel()]),
        ),
      ),
    );
  }
}

Widget _tampilTabel() {
  final controller = Get.find<RiwayatController>();

  return Obx(() {
    final data = controller.tabelData.isEmpty
        ? controller.dummyData
        : controller.tabelData;

    final page = controller.currentPage.value;
    final pageSize = 5;
    final totalPage = (data.length / pageSize).ceil();

    final start = page * pageSize;
    final end = (start + pageSize) > data.length
        ? data.length
        : start + pageSize;

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

        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(255, 105, 78, 109),
              width: 1.5,
            ),
          ),

          child: DataTable(
            columnSpacing: 0,
            horizontalMargin: 0,
            dataRowHeight: 44,
            headingRowHeight: 46,
            headingRowColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.1),
            ),

            columns: const [
              DataColumn(label: _HeaderText('Waktu')),
              DataColumn(label: _HeaderText('Suhu')),
              DataColumn(label: _HeaderText('Kelembapan')),
              DataColumn(label: _HeaderText('Status')),
            ],

            rows: pageData.map((row) {
              return DataRow(
                cells: [
                  DataCell(_CellText(row['created_at'] ?? '-')),
                  DataCell(_CellText('${row['temperature']}°C')),
                  DataCell(_CellText('${row['humidity']}%')),
                  DataCell(_CellText(row['status'] ?? '-')),
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: page > 0
                    ? () => controller.currentPage.value--
                    : null,
              ),
              Text(
                '${page + 1} / $totalPage',
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
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

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;
  const _CellText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
