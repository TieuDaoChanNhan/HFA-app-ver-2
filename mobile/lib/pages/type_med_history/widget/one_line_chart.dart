import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/pages/type_med_history/controller.dart';
import 'package:intl/intl.dart';

class OneLineChart extends StatefulWidget {
  @override
  final bool show_comment;
  final bool show_diagnostic;
  final bool show_alarm;
  final String title;
  const OneLineChart(
      {super.key,
      required this.show_comment,
      required this.show_diagnostic,
      required this.show_alarm,
      required this.title});
  @override
  _OneLineChartState createState() => _OneLineChartState();
}

class _OneLineChartState extends State<OneLineChart> {
  final controller = Get.find<TypeMedHistoryController>();
  // X-axis and Y-axis data based on random points generated earlier
  List<String> xAxisData = [];
  List<double> yAxisData = [];

  @override
  void initState() {
    super.initState();
    xAxisData = controller.result.values
        .expand((value) =>
            value.map((e) => DateFormat('dd/MM').format(e.time!.toDate())))
        .toList();
    yAxisData = controller.result.values
        .expand((value) {
          return value.map((e) => e.value!);
        })
        .map((e) => double.parse(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final minY =
        yAxisData.isEmpty ? 0 : yAxisData.reduce((a, b) => a < b ? a : b);
    final maxY =
        yAxisData.isEmpty ? 0 : yAxisData.reduce((a, b) => a > b ? a : b);
    const minX = 0;
    final maxX = xAxisData.length - 1;

    // Calculate intervals for 4 lines on Y-axis and smaller intervals for X-axis
    const yInterval = 5.0;
    const xInterval =
        1.0; // Decrease this value to show more frequent X-axis lines

    return Column(
      children: [
        Container(
          height: 310, // Adjusted height to account for padding and text
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 26, bottom: 26),
          child: LineChart(
            LineChartData(
              // Limit the number of grid lines to 4 on the Y-axis and more frequent on X-axis
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                verticalInterval: xInterval, // More frequent grid columns
                horizontalInterval: yInterval, // 4 grid row
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 35, // Adjust space for text
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < xAxisData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(xAxisData[index],
                              style: const TextStyle(fontSize: 10)),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    interval: xInterval, // More frequent X-axis labels
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40, // Adjust space for text
                    getTitlesWidget: (value, meta) {
                      return Text('$value',
                          style: const TextStyle(fontSize: 10));
                    },
                    interval: yInterval, // Keep Y-axis labels showing 4 lines
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide titles on the top
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide titles on the right
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
                    xAxisData.length,
                    (index) => FlSpot(
                      index.toDouble(), // X coordinate
                      yAxisData[index].toDouble(), // Y coordinate
                    ),
                  ),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData:
                      const FlDotData(show: true), // Display dots on the points
                  belowBarData: BarAreaData(
                    show: false,
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
              ],
              // lineTouchData: LineTouchData(
              //   touchTooltipData: LineTouchTooltipData(
              //     getTooltipColor: (spot) => Colors.blueAccent,
              //     getTooltipItems: (touchedSpots) {
              //       String y1 = touchedSpots[0].y.toInt().toString();
              //       return [
              //         LineTooltipItem(
              //           'Ngày: ${xAxisData[touchedSpots[0].x.toInt()]}\nHuyết áp:\n$y1',
              //           const TextStyle(color: Colors.white),
              //         ),
              //         const LineTooltipItem(
              //           '',
              //           TextStyle(color: Colors.white),
              //         ),
              //       ];
              //     },
              //   ),
              //   touchCallback:
              //       (FlTouchEvent event, LineTouchResponse? touchResponse) {
              //     if (!event.isInterestedForInteractions ||
              //         touchResponse == null) {
              //       return;
              //     }
              //     final touchedSpot = touchResponse.lineBarSpots?.first;
              //     if (touchedSpot != null) {
              //       // Handle touch interaction, if needed
              //     }
              //   },
              //   handleBuiltInTouches:
              //       true, // Allows built-in touch handling to show the tooltip
              // ),
            ),
          ),
        ),
        const Divider(
          height: 1,
        ),
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (widget.show_comment)
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Bình luận (1)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else if (widget.show_diagnostic)
                Row(
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Chẩn đoán (1)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Cảnh báo (1)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (widget.show_comment)
                CommentWidget(
                  name: 'Nguyễn Văn B',
                  time: '06:00',
                  date: '29/07/2024',
                  state: 'Đã bình luận',
                  medName: widget.title,
                  index: '125/80 mg/dL',
                  commend: 'Hơi cao. Đề nghị đo thêm vào buổi chiều',
                )
              else if (widget.show_diagnostic)
                DiagnosticWidget(
                  name: 'Nguyễn Văn B',
                  time: '06:00',
                  date: '29/07/2024',
                  state: 'Đã bình luận',
                  medName: widget.title,
                  index: '125/80 mg/dL',
                  commend: 'Hơi cao. Đề nghị đo thêm vào buổi chiều',
                )
              else
                AlarmWidget(
                  name: 'Nguyễn Văn B',
                  time: '06:00',
                  date: '29/07/2024',
                  state: 'Đã bình luận',
                  medName: widget.title,
                  index: '125/80 mg/dL',
                  commend: 'Hơi cao. Đề nghị đo thêm vào buổi chiều',
                ),
            ],
          ),
        ),*/
      ],
    );
  }
}
