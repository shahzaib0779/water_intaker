import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:water_intaker/model/water_model.dart';
import 'package:water_intaker/utils/date_helper.dart';

class WaterData extends ChangeNotifier {

  List<WaterModel> waterDataList=[];
  double _dailyTarget = 3700.0; // default


  //Add Water
   void saveWater(WaterModel water) async{
    final url =Uri.https('water-intaker-779-default-rtdb.firebaseio.com','savedWater.json');
    final response= await http.post(url,headers: {
      'Content-Type': 'application/json'
    },
    body:json.encode({
      'amount' : double.parse(water.amount.toString()),
      'unit' :  'ml',
      'dateTime' : DateTime.now().toString()
    })
    );

    if(response.statusCode == 200)
    {
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      waterDataList.add(WaterModel(id: extractedData['name'],amount: water.amount, unit:'ml', dateTime: water.dateTime,));
    }
    notifyListeners();
  }

  Future<List<WaterModel>> getWater()async
  {
    final url =Uri.https('water-intaker-779-default-rtdb.firebaseio.com','savedWater.json');
    final response = await http.get(url);

    if(response.statusCode ==200)
    {

      waterDataList.clear();

      //We are good to go
      final extractedData = json.decode(response.body);

      if(extractedData==null)
      {
        return waterDataList;
      }

      final dataMap = extractedData as Map<String,dynamic>;
      for (var element in dataMap.entries) {
        waterDataList.add
        (WaterModel(
        id: element.key,
        amount: element.value['amount'],
        unit: element.value['unit'],
        dateTime: DateTime.parse(element.value['dateTime']) ));
        
      }
    }

    notifyListeners();
    return waterDataList;

  }

  void delete(WaterModel waterObject) {
        final url =Uri.https('water-intaker-779-default-rtdb.firebaseio.com','savedWater/${waterObject.id}.json');
        http.delete(url);
        //Also remove from the list
        waterDataList.removeWhere((element)=> element.id == waterObject.id!);
        notifyListeners();
  }
  String getWeekDay (DateTime dateTime){
  switch(dateTime.weekday){
    case 1:
     return 'Mon';
    case 2:
     return 'Tue';
    case 3:
     return 'Wed';
    case 4:
     return 'Thu';
    case 5:
     return 'Fri';
    case 6:
     return 'Sat';
    case 7:
     return 'Sun';

    default:
     return '';
  }
}

DateTime getStartOfWeek()
{
  DateTime? startOfWeek;

  //Get Current date first
  DateTime dateTime =DateTime.now();

  for(int i=1;i<=7;i++){
    
    if(getWeekDay(dateTime.subtract(Duration(days: i))) == 'Sun'){
      startOfWeek = dateTime.subtract(Duration(days: i));
    }
  }

  return startOfWeek!;
}

//Calculate weekly water intake
String CalculateWeeklyWaterIntake(WaterData water)
{
  double totalWaterAmount = 0;

  for(var water in water.waterDataList){
    totalWaterAmount = totalWaterAmount + double.parse(water.amount.toString());
  }

  return totalWaterAmount.toStringAsFixed(2);

}

Map<String,double> calculateDailyWaterSummary()
{
  Map<String,double> dailyWaterIntake ={};

  for(var water in waterDataList)
  {
    String dateTime = convertDateTimeToString(water.dateTime);
    double amount = double.parse( water.amount.toString()) ;

       if(dailyWaterIntake.containsKey(dateTime))
       {
        double currentAmount = dailyWaterIntake[dateTime]!;
        currentAmount =currentAmount + amount;

        dailyWaterIntake[dateTime] =currentAmount;
       }
       else
       {
        dailyWaterIntake.addAll({dateTime:amount});
       }
  }

  return dailyWaterIntake;
}
  double get dailyTarget => _dailyTarget;

  void updateDailyTarget(double target) {
    _dailyTarget = target;
    notifyListeners();
  }

}
