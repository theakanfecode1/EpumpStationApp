
//flutter packages pub run build_runner build --delete-conflicting-outputs
import 'package:epump/utils/branch/branchwallet.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'branchwalletstore.g.dart';

class BranchWalletStore = _BranchWalletStore with _$BranchWalletStore;

abstract class _BranchWalletStore with Store{

  @observable
  BranchWallet branchWallet = BranchWallet(accountName: "",balance: 0.00,accountNumber: "",bankCode: "",bank: "");



  @action
  Future<String> getBranchWallet() async {
    branchWallet = BranchWallet(accountName: "",balance: 0.00,accountNumber: "",bankCode: "",bank: "");
    dynamic response = await NetworkRequest.getBranchWallet();

    switch(response["statusCode"]){
      case 200:
        branchWallet = response["object"];
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
  Future<String> postCashOut(double amount) async {
    dynamic response = await NetworkRequest.postCashOut(amount);

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

  @action
  Future<String> addBranchWallet(String bankName,String accountName,String bankCode,String payTime,String accountNumber) async {
    dynamic response = await NetworkRequest.postBranchWallet(bankName, accountName, bankCode, payTime, accountNumber);

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