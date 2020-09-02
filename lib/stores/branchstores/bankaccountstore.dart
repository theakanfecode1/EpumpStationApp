
import 'package:epump/utils/branch/bankaccount.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'bankaccountstore.g.dart';

class BankAccountStore = _BankAccountStore with _$BankAccountStore;

abstract class _BankAccountStore with Store{

  @observable
  List<BankAccount> accounts = [];

  @action
  Future<String> getBankAccounts() async {
    accounts = [];
    dynamic response = await NetworkRequest.getBankAccounts();

    switch(response["statusCode"]){
      case 200:
        accounts = response["object"];
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