import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/models/energy_report_model.dart';

class EnergyReportService {
  final String apiUrl = "http://localhost:3000/energy_report";

  Future<EnergyReport> fetchEnergyReport() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return EnergyReport.fromJson(data);
    } else {
      throw Exception("Failed to load energy report");
    }
  }
}
