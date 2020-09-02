import 'package:epump/utils/branch/bank.dart';
import 'package:epump/utils/branch/bankdeposit.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'bankdepositstore.g.dart';

class BankDepositStore = _BankDepositStore with _$BankDepositStore;

abstract class _BankDepositStore with Store{
  @observable
  List<BankDeposit> deposits= [];

  @action
  Future<String> getBankDeposits(String startDate,String endDate) async {
    deposits = [];
    dynamic response = await NetworkRequest.getBankDeposits(startDate, endDate);

    switch(response["statusCode"]){
      case 200:
        deposits = response["object"];
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

  @action
  Future<String> addBankDeposit(dynamic amount,String account,String tellerNumber) async {
    dynamic response = await NetworkRequest.postDeposit(amount, account, tellerNumber);

    switch(response["statusCode"]){
      case 200:
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
