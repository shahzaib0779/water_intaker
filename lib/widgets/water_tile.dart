import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intaker/data/water_data.dart';
import 'package:water_intaker/model/water_model.dart';

class waterTile extends StatelessWidget {
  const waterTile({
    super.key,
    required this.waterObject,
  });

  final WaterModel waterObject;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.water_drop,color: Colors.blue,size: 20,),
            Text("${waterObject.amount.toStringAsFixed(2)} ml",style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        subtitle: Text("${waterObject.dateTime.day}/${waterObject.dateTime.month}"),
        trailing: IconButton(onPressed:(){
          Provider.of<WaterData>(context,listen: false).delete(waterObject);
        }, icon: Icon(Icons.delete)),
      ),
    );
  }
}