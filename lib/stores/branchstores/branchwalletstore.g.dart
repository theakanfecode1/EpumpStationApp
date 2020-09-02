// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branchwalletstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BranchWalletStore on _BranchWalletStore, Store {
  final _$branchWalletAtom = Atom(name: '_BranchWalletStore.branchWallet');

  @override
  BranchWallet get branchWallet {
    _$branchWalletAtom.reportRead();
    return super.branchWallet;
  }

  @override
  set branchWallet(BranchWallet value) {
    _$branchWalletAtom.reportWrite(value, super.branchWallet, () {
      super.branchWallet = value;
    });
  }

  final _$getBranchWalletAsyncAction =
      AsyncAction('_BranchWalletStore.getBranchWallet');

  @override
  Future<String> getBranchWallet() {
    return _$getBranchWalletAsyncAction.run(() => super.getBranchWallet());
  }

  final _$postCashOutAsyncAction =
      AsyncAction('_BranchWalletStore.postCashOut');

  @override
  Future<String> postCashOut(double amount) {
    return _$postCashOutAsyncAction.run(() => super.postCashOut(amount));
  }

  final _$addBranchWalletAsyncAction =
      AsyncAction('_BranchWalletStore.addBranchWallet');

  @override
  Future<String> addBranchWallet(String bankName, String accountName,
      String bankCode, String payTime, String accountNumber) {
    return _$addBranchWalletAsyncAction.run(() => super.addBranchWallet(
        bankName, accountName, bankCode, payTime, accountNumber));
  }

  @override
  String toString() {
    return '''
branchWallet: ${branchWallet}
    ''';
  }
}
