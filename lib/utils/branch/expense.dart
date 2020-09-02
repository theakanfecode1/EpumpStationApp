//http://api.epump.com.ng/Branch/Expenses/6a237865-91ec-4c58-8b75-d7333e4cb4e6?startDate=""&endDate="

import 'package:intl/intl.dart';

class Expense{
  dynamic amount;
  String paymentMode;
  dynamic date;
  String description;
  String account;

  Expense({this.amount, this.paymentMode, this.date, this.description,this.account});

  factory Expense.fromJson(Map<String,dynamic> json){
    return Expense(
      amount: json["amount"] == null?0.00:json["amount"],
      paymentMode: json["paymentMode"] == null?"":json["paymentMode"],
      date: json["date"] == null?"": DateFormat.yMMMMEEEEd().format(DateTime.parse(json["date"]))+" "+DateFormat.jm().format(DateTime.parse(json["date"])),
      description: json["description"] == null?"":json["description"],
      account: json["account"] == null ? "":json["account"]
    );
  }


}





//{
//"account": "",
//"amount": 2,
//"branchId": "6a237865-91ec-4c58-8b75-d7333e4cb4e6",
//"category": null,
//"paymentMode": "Cash",
//"expenseCategory": null,
//"description": "test\n",
//"date": "2020-08-13T11:30:28.953"
//}



