// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bankaccountstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BankAccountStore on _BankAccountStore, Store {
  final _$accountsAtom = Atom(name: '_BankAccountStore.accounts');

  @override
  List<BankAccount> get accounts {
    _$accountsAtom.reportRead();
    return super.accounts;
  }

  @override
  set accounts(List<BankAccount> value) {
    _$accountsAtom.reportWrite(value, super.accounts, () {
      super.accounts = value;
    });
  }

  final _$getBankAccountsAsyncAction =
      AsyncAction('_BankAccountStore.getBankAccounts');

  @override
  Future<String> getBankAccounts() {
    return _$getBankAccountsAsyncAction.run(() => super.getBankAccounts());
  }

  @override
  String toString() {
    return '''
accounts: ${accounts}
    ''';
  }
}
