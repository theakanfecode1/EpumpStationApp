//http://api.epump.com.ng/Branch/StaffShifts/6a237865-91ec-4c58-8b75-d7333e4cb4e6?startDate=""&endDate=""

import 'package:intl/intl.dart';

class Shift{
  String name;
  dynamic startTime;
  dynamic endTime;
  bool closed;
  dynamic sync;
  String id;

  Shift({this.name, this.startTime, this.endTime, this.closed, this.sync,
      this.id});
  factory Shift.fromJson(Map<String,dynamic> json){
    return Shift(
      name: json["name"] == null?"":json["name"],
      startTime: json["startTime"] == null?"": DateFormat.yMMMMEEEEd().format(DateTime.parse(json["startTime"]))+" "+DateFormat.jm().format(DateTime.parse(json["startTime"])),
      endTime: json["endTime"] == null?"": DateFormat.yMMMMEEEEd().format(DateTime.parse(json["endTime"]))+" "+DateFormat.jm().format(DateTime.parse(json["endTime"])),
      closed: json["closed"],
      sync: json["sync"] == null?"":json["sync"],
      id: json["id"] == null?"":json["id"],
    );
  }

}