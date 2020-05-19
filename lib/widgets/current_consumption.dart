import 'package:WaterReminder/providers/Consumption.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CurrentConsumptionWidget extends StatefulWidget {
  @override
  _CurrentConsumptionWidgetState createState() =>
      _CurrentConsumptionWidgetState();
}

class _CurrentConsumptionWidgetState extends State<CurrentConsumptionWidget> {
  @override
  Widget build(BuildContext context) {
    final consumption = Provider.of<Consumption>(context);
    return Expanded(
      flex: 12,
      child: Container(
        margin: EdgeInsets.only(top: 16),
        child: Card(
          child: Center(
            child: FutureBuilder<double>(
              future: consumption.getConsumptionToday,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _buildIndicator(
                      context, snapshot.data, consumption.getUserGoal);
                } else {
                  return _buildEmptyState(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/empty_glass.png",
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'No drinks added today',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(
      BuildContext context, double consumptionToday, double userGoal) {
    return new CircularPercentIndicator(
      radius: 250.0,
      lineWidth: 30.0,
      animation: true,
      percent: consumptionToday > userGoal ? 1 : consumptionToday / userGoal,
      center: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Done',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              '${consumptionToday.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'of ${userGoal.toStringAsFixed(0)} ml today',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Theme.of(context).accentColor, Colors.blueAccent],
      ),
    );
  }
}
