import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_intaker/bars/bar_data.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key, required this.maxY,
  required this.sunWaterAmt,
  required this.monWaterAmt, 
  required this.tueWaterAmt, 
  required this.wedWaterAmt, 
  required this.thuWaterAmt, 
  required this.friWaterAmt, 
  required this.satWaterAmt});

  final double maxY;
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thuWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(sunAmount: sunWaterAmt, monAmount: monWaterAmt, tueAmount: tueWaterAmt, wedAmount: wedWaterAmt, thuAmount: thuWaterAmt, friAmount: friWaterAmt, satAmount: satWaterAmt);
    barData.initalizeBars();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,getTitlesWidget: bottomTextWidget))
        ),
        maxY: maxY,
        minY: 0,
        barGroups: barData.bars.map((data)=>BarChartGroupData(x:data.x,barRods: [
          BarChartRodData(
            toY: data.y,
            color: Colors.blue[300],
            width: 20,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color:const Color.fromARGB(255, 184, 214, 238)
            )

            )
        ])).toList()
      )),
    );
  }

  Widget bottomTextWidget(double value, TitleMeta meta) {

    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );

    Widget text;

    switch (value.toInt()) {
      case 0:
       text=Text('S',style: textStyle,);
       break;
      case 1:
       text=Text('M',style: textStyle,);
       break;
      case 2:
       text=Text('T',style: textStyle,);
       break;
      case 3:
       text=Text('W',style: textStyle,);
       break;
      case 4:
       text=Text('T',style: textStyle,);
       break;
      case 5:
       text=Text('F',style: textStyle,);
       break;
      case 6:
       text=Text('S',style: textStyle,);
       break;
      default:
       text = Text('');
       break;
    }
    return SideTitleWidget(meta: meta, child: text);
  }
}