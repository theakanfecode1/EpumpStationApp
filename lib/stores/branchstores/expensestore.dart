

import 'package:epump/utils/branch/expense.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'expensestore.g.dart';

class ExpenseStore = _ExpenseStore with _$ExpenseStore;

abstract class _ExpenseStore with Store{

  @observable
  List<Expense> expenses = [];

  @observable
  dynamic totalExpenses = 0.00;

  @action
  Future<String> getExpenses(String startDate,String endDate) async {
    expenses = [];
    totalExpenses =0;

    dynamic response = await NetworkRequest.getExpenses(startDate, endDate);

    switch(response["statusCode"]){
      case 200:
        expenses = response["object"];
        expenses.forEach((element) {
          totalExpenses += element.amount;
        });
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }

  }

}