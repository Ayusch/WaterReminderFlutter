import 'package:WaterReminder/database/database_helper.dart';
import 'package:WaterReminder/models/water_consumption_model.dart';
import 'package:flutter/material.dart';

class Consumption extends ChangeNotifier {
  double _userGoal = 3000;
  double _consumptionToday = 0;
  DateTime appSelectedDate = DateTime.now();

  double get getUserGoal {
    return _userGoal;
  }

  DateTime get getAppSelectedDate {
    return appSelectedDate;
  }

  void setAppSelectedDate(DateTime dateTime) {
    appSelectedDate = dateTime;
    notifyListeners();
  }

  Future<double> get getConsumptionToday async {
    var databaseHelper = DatabaseHelper.instance;
    return await databaseHelper.getConsumptionForDate(appSelectedDate);
  }

  void addConsumption(double quantity, DateTime dateTime) async {
    var databaseHelper = DatabaseHelper.instance;
    await databaseHelper
        .insert(WaterConsumption(quantity: quantity, dateTime: dateTime));
    var total = await databaseHelper.getConsumptionForDate(dateTime);
    _consumptionToday = total;
    notifyListeners();
  }
}
