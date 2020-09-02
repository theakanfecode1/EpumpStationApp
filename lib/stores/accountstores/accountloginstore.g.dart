// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountloginstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountLoginStore on _AccountLoginStore, Store {
  final _$loginDetailsAtom = Atom(name: '_AccountLoginStore.loginDetails');

  @override
  AccountLogin get loginDetails {
    _$loginDetailsAtom.reportRead();
    return super.loginDetails;
  }

  @override
  set loginDetails(AccountLogin value) {
    _$loginDetailsAtom.reportWrite(value, super.loginDetails, () {
      super.loginDetails = value;
    });
  }

  final _$loginUserAsyncAction = AsyncAction('_AccountLoginStore.loginUser');

  @override
  Future<String> loginUser(String username, String password) {
    return _$loginUserAsyncAction
        .run(() => super.loginUser(username, password));
  }

  @override
  String toString() {
    return '''
loginDetails: ${loginDetails}
    ''';
  }
}
