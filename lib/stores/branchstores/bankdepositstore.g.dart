// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bankdepositstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BankDepositStore on _BankDepositStore, Store {
  final _$depositsAtom = Atom(name: '_BankDepositStore.deposits');

  @override
  List<BankDeposit> get deposits {
    _$depositsAtom.reportRead();
    return super.deposits;
  }

  @override
  set deposits(List<BankDeposit> value) {
    _$depositsAtom.reportWrite(value, super.deposits, () {
      super.deposits = value;
    });
  }

  final _$getBankDepositsAsyncAction =
      AsyncAction('_BankDepositStore.getBankDeposits');

  @override
  Future<String> getBankDeposits(String startDate, String endDate) {
    return _$getBankDepositsAsyncAction
        .run(() => super.getBankDeposits(startDate, endDate));
  }

  final _$addBankDepositAsyncAction =
      AsyncAction('_BankDepositStore.addBankDeposit');

  @override
  Future<String> addBankDeposit(
      dynamic amount, String account, String tellerNumber) {
    return _$addBankDepositAsyncAction
        .run(() => super.addBankDeposit(amount, account, tellerNumber));
  }

  @override
  String toString() {
    return '''
deposits: ${deposits}
    ''';
  }
}
