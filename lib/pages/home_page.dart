import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intaker/data/water_data.dart';
import 'package:water_intaker/model/water_model.dart';
import 'package:water_intaker/pages/aboutScreen.dart';
import 'package:water_intaker/pages/settings_screen.dart';
import 'package:water_intaker/utils/date_helper.dart';
import 'package:water_intaker/widgets/water_intake_summary.dart';
import 'package:water_intaker/widgets/water_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = true;
  bool isError = false;
  String todayDate = convertDateTimeToString(DateTime.now());

  @override
  void initState() {
    loadingWater();
     super.initState();

    loadDailyTarget().then((value) {
    dailyAmountController.text = value.toString();
    Provider.of<WaterData>(context, listen: false)
    .updateDailyTarget(double.parse(dailyAmountController.text));
    
  });
  }

  Future<void> saveDailyTarget(double target) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('dailyTarget', target);
}

Future<double> loadDailyTarget() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('dailyTarget') ?? 3700.0; // fallback default
}

 void loadingWater() async {
  setState(() {
    isLoading = true;
  });

  try {
    final waters = await Provider.of<WaterData>(context, listen: false).getWater();

    setState(() {
      isLoading = false;
    });

    if (waters.isEmpty) {
      debugPrint("No water data found.");
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    debugPrint("Error fetching water data: $e");
  }
}

  final amountController = TextEditingController();
  final dailyAmountController = TextEditingController(text: '3700');

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

  void addDailyWater(){
    showDialog(context: context, builder: (context) =>
    AlertDialog(
      title: Text("Daily Intake Amount",style: TextStyle(fontSize: 20),),
      content:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10,),
          TextField(
            controller: dailyAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Amount in ml'
            ),
          )
        ],
      ) ,

      actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Cancel")),
      TextButton(onPressed: (){

      if(dailyAmountController.text.isNotEmpty)
      {
         saveDailyTarget(double.parse(dailyAmountController.text));
          Provider.of<WaterData>(context, listen: false)
         .updateDailyTarget(double.parse(dailyAmountController.text));
        Navigator.pop(context);
        SnackBar snackBar = SnackBar(content: Text("Daily Water Intake Updated!"),
        backgroundColor: Theme.of(context).colorScheme.primary,duration: Duration(seconds: 1),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
       }

      }, child: Text("Save")),
      
      ],

    )
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
            IconButton(onPressed: (){
            addDailyWater();

            }, icon: Icon(Icons.local_drink_rounded))
          ],
          centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Weekly: ",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
            Text('${value.CalculateWeeklyWaterIntake(value)}ml',style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        ),

        body: ListView(
          children:[

            WaterIntakeSummary(startOfWeek: value.getStartOfWeek()),
            //Water Amount in Database

                  Row(
          mainAxisAlignment: MainAxisAlignment.end, // push card to right
          children: [
            Flexible(
              child: Card(
                color: Colors.blue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    (() {
                      final remaining = value.dailyTarget;
                      final consumed = value.calculateDailyWaterSummary()[todayDate] ?? 0.0;
                      final left = remaining - consumed;
              
                      return left > 0
                          ? "Remaining Today: ${left.toStringAsFixed(0)} ml"
                          : "Hurrah! You have completed your daily intake 🎉";
                    })(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

            value.waterDataList.isNotEmpty?
            !isLoading? Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              itemCount: value.waterDataList.length,
              itemBuilder:(context, index) {
                final waterObject = value.waterDataList[index];
                return waterTile(waterObject: waterObject);
                        } ),
            ) : Center(child: Column(mainAxisAlignment:MainAxisAlignment.center,spacing: 3,
          children: [CircularProgressIndicator(),Text("Loading Data...")],)):Center(child: Padding(
            padding: const EdgeInsets.only(top:100),
            child: Text("No water data found"),
          ),),
          ],
          
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
        onPressed:addWater,
        child: Icon(Icons.add)),

        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(decoration: BoxDecoration(
                color: Colors.blue,
              ) , child: Text("Water Intake Go",style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              ),
              ListTile(
                leading: Icon(Icons.contact_page),
                title: Text("Contact Us",style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactPage()));
                }
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About",style: TextStyle(fontWeight: FontWeight.w600)),
                 onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutScreen()));
                },
              ),
            ],
          ),
        ),


      ),

    );
  }
  
  void clearWater() {

    amountController.clear();
  }
}
