import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intaker/data/water_data.dart';
import 'package:water_intaker/model/water_model.dart';
import 'package:water_intaker/widgets/water_intake_summary.dart';
import 'package:water_intaker/widgets/water_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    
    loadingWater();
    super.initState();
  }

  void loadingWater() async
  {
   await Provider.of<WaterData>(context,listen: false).getWater().then((waters)=> {

    if(waters.isNotEmpty)
    {
      setState(() {
        isLoading =false;
      })
    }

    else
    {
      setState(() {
        isLoading =true;
      })

    }
   });


  }

  final amountController = TextEditingController();

  void saveWater() async{

    Provider.of<WaterData>(context,listen: false).
    saveWater(WaterModel(amount: double.parse(amountController.text),
     unit: 'ml',
    dateTime: DateTime.now()));

    if(!context.mounted)
    {
      return; //Do nothing if not mounted
    }

    clearWater();
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
              errorText: isError? "Please enter value to save" : null,
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

      if(amountController.text.isEmpty)
      {
        setState(() {
          isError =true;
        });
      } else{
        setState(() {
          isError = false;
        });
      }
  
       if(isError == false)
       {
       saveWater();
        Navigator.pop(context);
        SnackBar snackBar = SnackBar(content: Text("Water Amount Saved!"),
        backgroundColor: Theme.of(context).colorScheme.primary,duration: Duration(seconds: 1),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
       }

      }, child: Text("Save")),
      
      ],
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
      builder: (context, value, child) =>
      Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.car_crash))
          ],
          centerTitle: true,
          title: Text("Water"),
        ),

        body: ListView(
          children:[

            WaterIntakeSummary(startOfWeek: value.getStartOfWeek()),
            //Water Amount in Database
            !isLoading? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            itemCount: value.waterDataList.length,
            itemBuilder:(context, index) {
              final waterObject = value.waterDataList[index];
              return waterTile(waterObject: waterObject);
          } ) : Center(child: Column(mainAxisAlignment:MainAxisAlignment.center,spacing: 3,
          children: [CircularProgressIndicator(),Text("Loading Data...")],)),
          ]
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
        onPressed:addWater,
        child: Icon(Icons.add)),
      ),
    );
  }
  
  void clearWater() {

    amountController.clear();
  }
}
