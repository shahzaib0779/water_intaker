import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intaker/bars/bar_graph.dart';
import 'package:water_intaker/data/water_data.dart';
import 'package:water_intaker/utils/date_helper.dart';

class WaterIntakeSummary extends StatelessWidget {

  final DateTime startOfWeek;
  const WaterIntakeSummary({super.key, required this.startOfWeek});


  double calculateMaxAmount(WaterData waterData,
  String sunday,
  String monday,
  String tuesday,
  String wednesday,
  String thursday,
  String friday,
  String saturday,){

    double? maxAmount = 100;
    List<double> value =[
     waterData.calculateDailyWaterSummary()[sunday]?? 0, 
     waterData.calculateDailyWaterSummary()[monday]?? 0,
     waterData.calculateDailyWaterSummary()[tuesday]?? 0, 
     waterData.calculateDailyWaterSummary()[wednesday]?? 0, 
     waterData.calculateDailyWaterSummary()[thursday]?? 0, 
     waterData.calculateDailyWaterSummary()[friday]?? 0,
     waterData.calculateDailyWaterSummary()[saturday]?? 0,
    ];

    value.sort();
    maxAmount = value.last * 1.3;

    return maxAmount ==0 ? 100:maxAmount;
  }

  @override
  Widget build(BuildContext context) {

    final String sunday = convertDateTimeToString(startOfWeek.add(Duration(days: 0)));
    final String monday = convertDateTimeToString(startOfWeek.add(Duration(days: 1)));
    final String tuesday = convertDateTimeToString(startOfWeek.add(Duration(days: 2)));
    final String wednesday = convertDateTimeToString(startOfWeek.add(Duration(days: 3)));
    final String thursday = convertDateTimeToString(startOfWeek.add(Duration(days: 4)));
    final String friday = convertDateTimeToString(startOfWeek.add(Duration(days: 5)));
    final String saturday = convertDateTimeToString(startOfWeek.add(Duration(days: 6)));
    return Consumer<WaterData>(builder: (context, value, child) => 
    SizedBox(
      height: 200,
      child: BarGraph(maxY: calculateMaxAmount(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday), 
      sunWaterAmt: value.calculateDailyWaterSummary()[sunday]?? 0, 
      monWaterAmt: value.calculateDailyWaterSummary()[monday]?? 0,
      tueWaterAmt: value.calculateDailyWaterSummary()[tuesday]?? 0, 
      wedWaterAmt: value.calculateDailyWaterSummary()[wednesday]?? 0, 
      thuWaterAmt: value.calculateDailyWaterSummary()[thursday]?? 0, 
      friWaterAmt: value.calculateDailyWaterSummary()[friday]?? 0,
      satWaterAmt: value.calculateDailyWaterSummary()[saturday]?? 0,
      
      ),
    )
    );
  }
}