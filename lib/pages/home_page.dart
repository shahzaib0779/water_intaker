import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final amountController = TextEditingController();

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