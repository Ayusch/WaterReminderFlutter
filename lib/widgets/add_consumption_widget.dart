import 'package:WaterReminder/providers/Consumption.dart';
import 'package:WaterReminder/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddConsumptionWidget extends StatefulWidget {
  const AddConsumptionWidget({Key key}) : super(key: key);

  @override
  _AddConsumptionWidgetState createState() => _AddConsumptionWidgetState();
}

class _AddConsumptionWidgetState extends State<AddConsumptionWidget> {
  final _formKey = GlobalKey<FormState>();
  double _inputQty = 0;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _form(context),
      ),
    );
  }

  Widget _form(BuildContext ctx) {
    final consumptionProvider = Provider.of<Consumption>(ctx, listen: false);
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "Add a glass of water",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: _pickDate,
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      DateFormat(Constants.APP_DATE_DISPLAY_FORMAT)
                          .format(selectedDate),
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 2.0),
                      ),
                      hintText: 'Enter in (ml)',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return "Please enter a quantity";
                      return null;
                    },
                    onSaved: (value) {
                      _inputQty = double.parse(value);
                    },
                  ),
                ),
                ClipRRect(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green,
                    child: IconButton(
                      icon: Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () => _addQuantity(ctx, consumptionProvider),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(100),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addQuantity(BuildContext ctx, dynamic consumptionProvider) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    await consumptionProvider.addConsumption(_inputQty, selectedDate);
    Navigator.of(ctx).pop();
  }

  void _pickDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }
}
