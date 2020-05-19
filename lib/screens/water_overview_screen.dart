import 'package:WaterReminder/database/database_helper.dart';
import 'package:WaterReminder/screens/statistics_screen.dart';
import 'package:WaterReminder/widgets/add_consumption_widget.dart';
import 'package:WaterReminder/widgets/bottom_app_bar.dart';
import 'package:WaterReminder/widgets/current_consumption.dart';
import 'package:WaterReminder/widgets/selected_date_bar.dart';
import 'package:flutter/material.dart';

class WaterOverviewScreen extends StatefulWidget {
  @override
  _WaterOverviewScreenState createState() => _WaterOverviewScreenState();
}

class _WaterOverviewScreenState extends State<WaterOverviewScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': StatisticsScreen(),
        'title': 'Statistics',
      },
      {
        'page': WaterOverviewScreen(),
        'title': 'Overview',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).accentColor,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectPage,
        items: [
          FABBottomAppBarItem(iconData: Icons.pie_chart, text: 'Statistics'),
          FABBottomAppBarItem(iconData: Icons.remove_red_eye, text: 'Overview'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _triggerBottomSheet(context);
        },
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: _buildBody(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _triggerBottomSheet(BuildContext ctx) {
    DatabaseHelper.instance.queryRowsForMonthYear(DateTime.now());

    showModalBottomSheet(
        context: ctx,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        builder: (ctx) {
          return GestureDetector(
            onTap: () {},
            child: AddConsumptionWidget(),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  Widget _buildBody() {
    if (_selectedPageIndex == 1)
      return Container(
        margin: EdgeInsets.only(bottom: 40),
        padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SelectedDateBar(),
            CurrentConsumptionWidget(),
          ],
        ),
      );
    else
      return StatisticsScreen();
  }
}
