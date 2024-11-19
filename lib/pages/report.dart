import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project/services/energy_report_service.dart';
import 'package:project/models/energy_report_model.dart';
import 'package:project/resources/app_colors.dart';
import 'package:project/utils/extensions/color_ext.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final EnergyReportService _energyReportService = EnergyReportService();
  late Future<EnergyReport> _energyReportFuture;

  @override
  void initState() {
    super.initState();
    _energyReportFuture = _energyReportService.fetchEnergyReport();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EnergyReport>(
      future: _energyReportFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final energyReport = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '이번 주 에너지 사용량',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: Colors.black,
                    elevation: 16.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            '요일별 에너지 사용량',
                            style: TextStyle(color: Colors.white),
                          ),
                          _WeeklyBarChart(dailyUsage: energyReport.dailyUsage),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: Colors.black,
                    elevation: 16.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            '일주일 사용량 비교',
                            style: TextStyle(color: Colors.white),
                          ),
                          _SummaryBarChart(
                              totalUsage: energyReport.totalUsage,
                              averageUsage: energyReport.averageUsage),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No report data available'));
        }
      },
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<DailyUsage> dailyUsage;

  const _WeeklyBarChart({required this.dailyUsage, Key? key}) : super(key: key);

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppColors.contentColorBlue.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: 10,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = '월';
                      break;
                    case 1:
                      text = '화';
                      break;
                    case 2:
                      text = '수';
                      break;
                    case 3:
                      text = '목';
                      break;
                    case 4:
                      text = '금';
                      break;
                    case 5:
                      text = '토';
                      break;
                    case 6:
                      text = '일';
                      break;
                    default:
                      text = '';
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
          ),
          barGroups: dailyUsage
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.usage,
                      gradient: _barsGradient,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SummaryBarChart extends StatelessWidget {
  final double totalUsage;
  final double averageUsage;

  const _SummaryBarChart({
    required this.totalUsage,
    required this.averageUsage,
    Key? key,
  }) : super(key: key);

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppColors.contentColorBlue.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: totalUsage > averageUsage ? totalUsage : averageUsage,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = '총 사용량';
                      break;
                    case 1:
                      text = '평균 사용량';
                      break;
                    default:
                      text = '';
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: totalUsage,
                  gradient: _barsGradient,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: averageUsage,
                  gradient: _barsGradient,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
