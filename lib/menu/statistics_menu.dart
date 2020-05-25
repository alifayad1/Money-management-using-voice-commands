import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/pie_chart.dart';
import 'package:thrifty/utils/transaction.dart';
import 'package:thrifty/pages/histogram.dart';

class StatisticsMenu extends StatelessWidget {
  List<TRansaction> ml;

  StatisticsMenu(List<TRansaction> transactions) {
    ml = transactions;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body:
          new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Icon(
            FontAwesomeIcons.chartLine,
            color: Constants.maincolor,
            size: 108,
          ),
          new Text(
            "Click on icons below for statistics : ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          new IconButton(
            iconSize: 150,
            icon: Icon(
              FontAwesomeIcons.chartPie,
              size: 150,
            ),
            color: Constants.maincolor,
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new PieChart(ml)));
            },
          ),
          new Text(
            "PIE CHART",
            style: TextStyle(
                color: Constants.maincolor,
                fontSize: 30,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          new IconButton(
            iconSize: 150,
            icon: Icon(
              FontAwesomeIcons.solidChartBar,
              size: 150,
            ),
            color: Constants.maincolor,
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Histogram()));
            },
          ),
          new Text(
            "HISTOGRAM\n\n",
            style: TextStyle(
                color: Constants.maincolor,
                fontSize: 30,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
        // ),
      ),
    );
  }
}
