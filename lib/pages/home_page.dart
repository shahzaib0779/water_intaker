import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final amountController = TextEditingController();

  void saveWater(String amount) async{
    final url =Uri.https('water-intaker-779-default-rtdb.firebaseio.com','savedWater.json');
    await http.post(url,headers: {
      'Content-Type': 'application/json'
    },
    body:json.encode({
      'amount' : double.parse(amount),
      'unit' :  'ml',
      'dateTime' : DateTime.now().toString()
    })
    );
    
  }

  void addWater(){
    showDialog(context: context, builder: (context) => 
    AlertDialog(
      title: Text("Add Water"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add water to your daily intake"),
          SizedBox(height: 10,),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                
              ),
              labelText: 'Amount'
            )
          )
        ],
      ),

      actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Cancel")),
      TextButton(onPressed: (){
        //We are going to save data in db here :)
        saveWater(amountController.text);
        Navigator.pop(context);

      }, child: Text("Save")),
      
      ],
    )
    );

    print(amountController.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.car_crash))
        ],
        centerTitle: true,
        title: Text("Water"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
      onPressed:addWater,
      child: Icon(Icons.add)),
    );
  }
}