import 'package:WaterReminder/models/water_consumption_model.dart';
import 'package:WaterReminder/providers/Consumption.dart';
import 'package:WaterReminder/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsChart extends StatelessWidget {
  final List<WaterConsumption> data;
  StatsChart({this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<WaterConsumption, String>> series = [
      charts.Series(
          id: "Consumption",
          data: data,
          domainFn: (WaterConsumption cons, _) =>
              DateFormat(Constants.APP_DATE_DISPLAY_FORMAT)
                  .format(cons.dateTime),
          measureFn: (WaterConsumption cons, _) => cons.quantity,
          colorFn: (WaterConsumption cons, _) =>
              charts.ColorUtil.fromDartColor(Theme.of(context).accentColor))
    ];

    return Expanded(
      flex: 12,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Consumer<Consumption>(
                  builder: (ctx, consumption, _) {
                    return Text(
                      "You water consumption for " +
                          DateFormat("MMM")
                              .format(consumption.getAppSelectedDate),
                      style: Theme.of(context).textTheme.headline5,
                    );
                  },
                ),
                SizedBox(height: 32),
                Expanded(
                  child: charts.BarChart(
                    series,
                    animate: true,
                    domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec:
                          charts.SmallTickRendererSpec(labelRotation: 60),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
