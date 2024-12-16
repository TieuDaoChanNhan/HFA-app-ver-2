import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/type_med_history/controller.dart';

class GraphChart extends StatefulWidget {
  @override
  final List<double> y;
  const GraphChart({super.key, required this.y});
  @override
  _GraphChartState createState() => _GraphChartState();
}

class _GraphChartState extends State<GraphChart> {
  final controller = Get.find<TypeMedHistoryController>();
  List<double> yAxisData = [];

  @override
  void initState() {
    super.initState();
    // Only initialize yAxisData without the xAxisData
    yAxisData = widget.y;
  }

  @override
  Widget build(BuildContext context) {
    final minY =
        yAxisData.isEmpty ? 0 : yAxisData.reduce((a, b) => a < b ? a : b);
    final maxY =
        yAxisData.isEmpty ? 0 : yAxisData.reduce((a, b) => a > b ? a : b);
    const minX = 0;
    final maxX = yAxisData.length - 1;

    // Calculate intervals for 4 lines on Y-axis
    const yInterval = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Biểu đồ"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 310, // Adjusted height to account for padding and text
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
              ),
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 26, bottom: 26),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine:
                        false, // Hide vertical lines (X-axis grid)
                    horizontalInterval: yInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.5),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Hide X-axis titles
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Hide Y-axis titles
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  minX: minX.toDouble(),
                  maxX: maxX.toDouble(),
                  minY: minY.toDouble() - yInterval,
                  maxY: maxY.toDouble() + yInterval,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        yAxisData.length,
                        (index) => FlSpot(
                          index.toDouble(), // X coordinate is the index
                          yAxisData[index].toDouble(), // Y coordinate
                        ),
                      ),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                          show: true), // Display dots on the points
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
