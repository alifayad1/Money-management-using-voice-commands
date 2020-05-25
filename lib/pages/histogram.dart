import 'package:flutter/material.dart';
import 'package:thrifty/main.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:thrifty/menu/caltest.dart';
import 'package:thrifty/pages/home.dart';

class Histogram extends StatefulWidget {

  Histogram({Key key, this.title}) : super(key: key);

  final String title;
  static bool isday = true;
  static String my = "by Days";
  static Color myc = Colors.lightGreen;
  static int columnz = 1;

 @override
  _HistogramState createState() => new _HistogramState();
}


class Amoud {
  final String namel;
  final double total;
  final charts.Color color;

  Amoud(this.namel, this.total, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _HistogramState extends State<Histogram> implements Updater {
  @override
  Widget build(BuildContext context) {
    var data = [
      new Amoud(Dates.date_for_transactions1, Requirements.totalperdate1,
          Colors.lightBlueAccent),
      new Amoud(Dates.date_for_transactions2, Requirements.totalperdate2,
          Colors.blue),
    ];
    var series = [
      new charts.Series(
        domainFn: (Amoud clickData, _) => clickData.namel,
        measureFn: (Amoud clickData, _) => clickData.total,
        colorFn: (Amoud clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 300.0,
        width: 600.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Histogram"),
        backgroundColor: Constants.maincolor,
        
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'By default comparaison between today and yesterday',
            ),
            chartWidget,
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    height: 10,
                    color: Colors.lightBlueAccent,
                    child: Text(
                      "Set date 1",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Histogram.columnz = 1;
                      showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                                title: new Text(
                                  "Calendar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: new Container(
                                    height: 400,
                                    width: 600,
                                    child: new Calendar(this)),
                              ));
                    }),
                new MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    height: 10,
                    color: Colors.blue,
                    child: Text(
                      "Set date 2",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Histogram.columnz = 2;
                      showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                                title: new Text(
                                  "Calendar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: new Container(
                                    height: 400,
                                    width: 600,
                                    child: new Calendar(this)),
                              ));

                      setState(() {});
                    }),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[SizedBox(
                height: 30.0,
              ),],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  height: 20,
                  color: Histogram.myc,
                  child: Text(
                    Histogram.my,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    
                    if (Histogram.isday.toString() == "true") {
                      Histogram.isday = false;
                      Histogram.my = "by Months";
                      Histogram.myc = Colors.green;
                      Dates.date_for_transactions1 = Dates.month1;
                    Dates.date_for_transactions2 = Dates.month2;
                      update();
                    } else {
                      Histogram.isday = true;
                      Histogram.my = "by Days";
                      Histogram.myc = Colors.lightGreen;
                      Dates.date_for_transactions1 = DateTime.now().toString().substring(0,10);
                      Dates.date_for_transactions2 = getdate22();
                      update();
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void update() {
    setState(() {});
  }
}

abstract class Updater {
  void update();
}
String getdate22(){
  if(DateTime.now().day!=1){

    return DateTime.now().toString().substring(0,8)+(DateTime.now().day-1).toString();

  }
  else{
      return DateTime.now().year.toString()+"-"+(DateTime.now().month-1).toString()+"-31";
  }
}
