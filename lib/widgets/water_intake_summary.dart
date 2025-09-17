import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intaker/bars/bar_graph.dart';
import 'package:water_intaker/data/water_data.dart';

class WaterIntakeSummary extends StatelessWidget {

  final DateTime startOfWeek;
  const WaterIntakeSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(builder: (context, value, child) => 
    SizedBox(
      height: 200,
      child: BarGraph(maxY: 100, 
      sunWaterAmt: 19, 
      monWaterAmt: 34, 
      tueWaterAmt: 10, 
      wedWaterAmt: 92, 
      thuWaterAmt: 72, 
      friWaterAmt: 77, 
      satWaterAmt: 46),
    )
    );
  }
}