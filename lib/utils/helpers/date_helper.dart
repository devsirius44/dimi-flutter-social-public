import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October','November', 'December'];

String getStringForMonth(int month) {
  print(month);
  if(month > 0 && month < 13) {
    return months[month];
  } else {
    return null;
  }
}

int getIntForMonth(String month) {
  for(int i = 0; i < 12; i++) {
    if(months[i] == month) {
      return i+1;
    }
  }
  return -1;
}

Future<DateTime> pickChargeDate({context= BuildContext}) async {

  var now = DateTime.now();
  final DateTime picked = await showDatePicker(
    context: context as BuildContext,
    initialDate: DateTime(now.year, now.month, now.day, now.hour),
    firstDate: DateTime(now.year, now.month, now.day, 0, 0, 0),
    lastDate: DateTime(2100, 1,1),
  );
  
  if(picked != null) {
    return picked;
  }
  return null;
}


///  Parse the timeString in format: DD/MM/YYYY

DateTime parseDate(String dateString) {
  var segments = dateString.toString().split('/');
  if(segments.length != 3) {
    return null;
  }

  try{
    int day = int.parse(segments[0]);
    int month = int.parse(segments[1]);
    int year = int.parse(segments[2]);

    if( 1960 < year && year < 2090 ) {
      if(month > 0 && month < 13) {
        if(day > 0 && day < 32) {
          return DateTime(year, month, day);
        }
      }
    }
    return null;
  } catch (error) {
    print('parse error = $error');
    return null;
  }
}

String convertTimeString(String timeString, String inputFormat, String outputFormat) {
   DateFormat originalFormat = DateFormat(inputFormat);
   DateTime dateTime = originalFormat.parse(timeString);
   DateFormat newFormat = DateFormat(outputFormat);
   return newFormat.format(dateTime);
}

DateTime parseDateTime(String strDateTime, String format) {
  DateFormat convertFormat = DateFormat(format);
  DateTime dateTime = convertFormat.parse(strDateTime);
  return dateTime;
}



String convertTimeWithFormat(String timeString, String format) {
  if(timeString == null) {
    return convertTimeString('1995-05-04', 'yyyy-MM-dd', format);
  } else {
    return convertTimeString(timeString, 'yyyy-MM-dd', format);
  }
}

String getDateStringWithFormat({dateTime = DateTime, format = String}) {
  return DateFormat(format as String).format(dateTime as DateTime);
}

String getTodayDateString() {
  return DateFormat('dd/MM/yyyy').format(DateTime.now());
}

