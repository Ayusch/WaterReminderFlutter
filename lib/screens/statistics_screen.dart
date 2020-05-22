import 'package:WaterReminder/database/database_helper.dart';
import 'package:WaterReminder/models/water_consumption_model.dart';
import 'package:WaterReminder/providers/Consumption.dart';
import 'package:WaterReminder/widgets/selected_date_bar.dart';
import 'package:WaterReminder/widgets/stats_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    DateTime date = Provider.of<Consumption>(context).getAppSelectedDate;
    return FutureBuilder(
      future: databaseHelper.queryRowsForMonthYear(date),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildWidgets(ctx, snapshot.data);
        } else
          return CircularProgressIndicator();
      },
    );
  }

  Widget _buildWidgets(BuildContext context, List<Map<String, dynamic>> data) {
    List<WaterConsumption> consumptionlist = WaterConsumption.fromMap(data);
    consumptionlist.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SelectedDateBar(),
          StatsChart(
            data: consumptionlist,
          ),
        ],
      ),
    );
  }
}
