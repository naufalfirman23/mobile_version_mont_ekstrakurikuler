import 'package:flutter/material.dart';
import 'package:mobile_version/const/cfont.dart';

class KehadiranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:Text(
              'Kehadiran Siswa',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
       
            SizedBox(height: 16),
            _buildLegend(),
            SizedBox(height: 24),
            Text(
              'Rekap Kehadiran Siswa',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceList() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 216, 224, 250),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildAttendanceRow('Pertemuan 1', '1 Januari 2024', Icons.check_circle, Colors.green),
          _buildAttendanceRow('Pertemuan 2', '1 Januari 2024', Icons.sick, Colors.blue),
          _buildAttendanceRow('Pertemuan 3', '1 Januari 2024', Icons.check_circle, Colors.green),
          _buildAttendanceRow('Pertemuan 4', '1 Januari 2024', Icons.cancel, Colors.red),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String pertemuan, String tanggal, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
        width: 1.0,
        color: Colors.grey[900]!,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(pertemuan, style: TextStyle(fontSize: 16)),
          Text(tanggal, style: TextStyle(fontSize: 16)),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 77, 93, 146),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text("Keterangan",
          style: TextStyle(fontSize: 16, fontFamily: FontType.interSemiBold, color: Colors.white)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Hadir', Colors.green),
              _buildLegendItem('Alpha', Colors.red),
              _buildLegendItem('Izin', Colors.yellow),
              _buildLegendItem('Sakit', Colors.blue),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 16),
        SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.white),),
      ],
    );
  }

  Widget _buildSummary() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 216, 224, 250),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildSummaryRow('Hadir', '4x'),
          _buildSummaryRow('Alpha', '0x'),
          _buildSummaryRow('Izin', '0x'),
          _buildSummaryRow('Sakit', '0x'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String count) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
        width: 1.0,
        color: Colors.grey[900]!,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(count, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
