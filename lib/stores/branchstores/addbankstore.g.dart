// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addbankstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddBankStore on _AddBankStore, Store {
  final _$banksAtom = Atom(name: '_AddBankStore.banks');

  @override
  List<Bank> get banks {
    _$banksAtom.reportRead();
    return super.banks;
  }

  @override
  set banks(List<Bank> value) {
    _$banksAtom.reportWrite(value, super.banks, () {
      super.banks = value;
    });
  }

  final _$getBanksAsyncAction = AsyncAction('_AddBankStore.getBanks');

  @override
  Future<String> getBanks() {
    return _$getBanksAsyncAction.run(() => super.getBanks());
  }

  final _$addBankAsyncAction = AsyncAction('_AddBankStore.addBank');

  @override
  Future<String> addBank(String bankName, String accountName, String bankCode,
      String accountNumber) {
    return _$addBankAsyncAction.run(
        () => super.addBank(bankName, accountName, bankCode, accountNumber));
  }

  @override
  String toString() {
    return '''
banks: ${banks}
    ''';
  }
}
