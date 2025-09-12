import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:water_intaker/model/water_model.dart';

class WaterData extends ChangeNotifier {

  List<WaterModel> waterDataList=[];

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
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      for (var element in extractedData.entries) {
        waterDataList.add
        (WaterModel(
        id: extractedData['name'],
        amount: element.value['amount'],
        unit: element.value['unit'],
        dateTime: DateTime.parse(element.value['dateTime']) ));
        
      }
    }

    notifyListeners();
    return waterDataList;

  }
}