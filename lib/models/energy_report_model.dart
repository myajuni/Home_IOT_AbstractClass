class DailyUsage {
  final String date; // 요일로 변경
  final double usage;

  DailyUsage({required this.date, required this.usage});

  factory DailyUsage.fromJson(Map<String, dynamic> json) {
    return DailyUsage(
      date: json['date'] ?? 'Unknown', // null일 경우 'Unknown'으로 처리
      usage: json['usage'] ?? 0.0,
    );
  }
}

class EnergyReport {
  final List<DailyUsage> dailyUsage;

  EnergyReport({required this.dailyUsage});

  factory EnergyReport.fromJson(Map<String, dynamic> json) {
    var dailyUsageList = (json['daily_usage'] as List)
        .map((item) => DailyUsage.fromJson(item))
        .toList();
    return EnergyReport(dailyUsage: dailyUsageList);
  }

  // 주간 총 사용량 및 평균 계산 메서드
  double get totalUsage => dailyUsage.fold(0, (sum, item) => sum + item.usage);
  double get averageUsage =>
      dailyUsage.isNotEmpty ? totalUsage / dailyUsage.length : 0.0;
}
