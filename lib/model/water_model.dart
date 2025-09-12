class WaterModel {
final String? id;
final double amount;
final DateTime dateTime;

  WaterModel({this.id, required this.amount, required String unit,required this.dateTime});

//Covert JSON Data from firebase to WaterModel
factory WaterModel.fromJson(Map<String,dynamic>json, String id )
{
  return WaterModel(
    id: id,
    amount: json['amount'],
    unit: json['unit'],
    dateTime: DateTime.parse(json['dateTime'])
    );
}

//Convert water model to JSON to save data in Firebase
Map<String,dynamic> toJson()
{
  return{
    'amount':amount,
    'dateTime':DateTime.now(),
  };
}

}