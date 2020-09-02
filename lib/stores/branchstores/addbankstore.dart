import 'package:epump/utils/branch/bank.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'addbankstore.g.dart';

class AddBankStore = _AddBankStore with _$AddBankStore;

abstract class _AddBankStore with Store{
  @observable
  List<Bank> banks;

  @action
  Future<String> getBanks() async {
    banks = [];
    dynamic response = await NetworkRequest.getBanks();

    switch(response["statusCode"]){
      case 200:
        banks = response["object"];
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
  Future<String> addBank(String bankName,String accountName,String bankCode,String accountNumber) async {
    dynamic response = await NetworkRequest.postBankAccount(bankName, accountName, bankCode, accountNumber);

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
