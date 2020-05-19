import 'package:WaterReminder/providers/Consumption.dart';
import 'package:WaterReminder/screens/water_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Consumption()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromRGBO(241, 242, 246, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          textTheme: TextTheme(
            headline5:
                TextStyle(color: Color.fromRGBO(54, 87, 119, 1), fontSize: 16),
            headline6:
                TextStyle(color: Color.fromRGBO(54, 87, 119, 1), fontSize: 14),
            headline2:
                TextStyle(color: Color.fromRGBO(54, 87, 119, 1), fontSize: 32),
            headline3:
                TextStyle(color: Color.fromRGBO(54, 87, 119, 1), fontSize: 26),
            headline4:
                TextStyle(color: Color.fromRGBO(54, 87, 119, 1), fontSize: 22),
          ),
        ),
        home: Container(
          child: WaterOverviewScreen(),
        ),
      ),
    );
  }
}
