import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepChart extends StatelessWidget {
  final List<double> sleepData;

  const SleepChart({super.key, required this.sleepData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(enabled: false),
          titlesData: const FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitles,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _createChartData(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createChartData() {
    return sleepData.asMap().entries.map((entry) {
      return _makeGroupData(entry.key, entry.value);
    }).toList();
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.deepPurpleAccent,
          width: 22,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  static Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.grey, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0: text = 'Mon'; break;
      case 1: text = 'Tue'; break;
      case 2: text = 'Wed'; break;
      case 3: text = 'Thu'; break;
      case 4: text = 'Fri'; break;
      case 5: text = 'Sat'; break;
      case 6: text = 'Sun'; break;
      default: text = ''; break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
  }
}
