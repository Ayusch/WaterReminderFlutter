import 'package:WaterReminder/providers/Consumption.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectedDateBar extends StatefulWidget {
  @override
  _SelectedDateBarState createState() => _SelectedDateBarState();
}

class _SelectedDateBarState extends State<SelectedDateBar> {
  @override
  Widget build(BuildContext context) {
    final consumption = Provider.of<Consumption>(context);

    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        child: Card(
          child: GestureDetector(
            onTap: () => _selectDate(context, consumption),
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat("EEEE").format(consumption.getAppSelectedDate),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat("d MMM, yyyy")
                          .format(consumption.getAppSelectedDate),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context, dynamic consumption) {
    showDatePicker(
      context: context,
      initialDate: consumption.getAppSelectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      consumption.setAppSelectedDate(pickedDate);
    });
  }
}
