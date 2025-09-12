import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intaker/data/water_data.dart';
import 'package:water_intaker/pages/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context)=>WaterData(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Intake',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: const HomePage(),
    );
  }
}
