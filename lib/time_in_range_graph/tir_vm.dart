import 'package:learning/time_in_range_graph/time_range.dart';
import 'package:stacked/stacked.dart';

class RegionData {
  final String region;
  final double percentage;

  RegionData(this.region, this.percentage);
}

class TIRVM extends BaseViewModel {
  final List<TimeRange> chartData = [
    TimeRange(DateTime(2026, 6, 18, 8, 0), 10.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 10.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 10.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 1.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 1.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 1.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 1.5),
    TimeRange(DateTime(2026, 6, 18, 8, 0), 1.5),
    TimeRange(DateTime(2026, 6, 18, 12, 0), 20.2),
    TimeRange(DateTime(2026, 6, 18, 16, 0), 15.0),
    TimeRange(DateTime(2026, 6, 18, 20, 0), 25.8),
    TimeRange(DateTime(2026, 6, 18, 20, 0), 25.8),
    TimeRange(DateTime(2026, 6, 18, 20, 0), 25.8),
    TimeRange(DateTime(2026, 6, 18, 20, 0), 25.8),
  ];

  List<RegionData> get regionPercentages {
    if (chartData.isEmpty) return [];

    int below = 0;
    int target = 0;
    int above = 0;

    for (var data in chartData) {
      if (data.value < 10) {
        below++;
      } else if (data.value >= 10 && data.value <= 20) {
        target++;
      } else {
        above++;
      }
    }

    final total = chartData.length;
    return [
      RegionData('Below Range', (below / total) * 100),
      RegionData('Target Range', (target / total) * 100),
      RegionData('Above Range', (above / total) * 100),
    ];
  }
}
