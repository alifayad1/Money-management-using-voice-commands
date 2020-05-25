import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:thrifty/main.dart';
import 'package:thrifty/pages/histogram.dart';
import 'package:thrifty/utils/database.dart';


class Calendar extends StatelessWidget {
  Updater _listener;
  
  Calendar(this._listener);
  
  
  @override
  Widget build(BuildContext context) {
    return new Column(
      
      children: <Widget>[
              TableCalendar(
                  locale: 'en_EN',
                  onDaySelected: (DateTime date, List events) async {
                   if(Histogram.columnz==1){
                  if(Histogram.isday.toString()=="true"){
                  Dates.date_for_transactions1=date.toString().substring(0,10);
                  Requirements.totalperdate1 = await getdayTranBalance(date.toString().substring(0,10)) ;
                  
                  _listener.update();
                  
                }else{
                   Dates.date_for_transactions1=date.toString().substring(0,7);
                  Requirements.totalperdate1 = await getmonthTranBalance(date.toString().substring(0,7)) ;
                  _listener.update();
                }}else if(Histogram.columnz==2){
                  if(Histogram.isday.toString()=="true"){
                  Dates.date_for_transactions2=date.toString().substring(0,10);
                  Requirements.totalperdate2 = await getdayTranBalance(date.toString().substring(0,10)) ;
                  
                  _listener.update();
                }else{
                   Dates.date_for_transactions2=date.toString().substring(0,7);
                  Requirements.totalperdate2 = await getmonthTranBalance(date.toString().substring(0,7));
                  _listener.update();
                }
                
                }
                else{
                  Dates.date_for_transactions=date.toString().substring(0,10);
                  Dates.date_for_pie_chart = date.toString().substring(0,10);
                  _listener.update();
                }
               Navigator.pop(context); 
               

               
                }
              ),
      ],          
    );
  }
}
PageController controller = PageController(initialPage: Requirements.currentIndex);
