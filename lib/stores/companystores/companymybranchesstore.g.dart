// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companymybranchesstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CompanyMyBranchesStore on _CompanyMyBranchesStore, Store {
  final _$companyAtom = Atom(name: '_CompanyMyBranchesStore.company');

  @override
  Company get company {
    _$companyAtom.reportRead();
    return super.company;
  }

  @override
  set company(Company value) {
    _$companyAtom.reportWrite(value, super.company, () {
      super.company = value;
    });
  }

  final _$getBranchAsyncAction =
      AsyncAction('_CompanyMyBranchesStore.getBranch');

  @override
  Future<String> getBranch() {
    return _$getBranchAsyncAction.run(() => super.getBranch());
  }

  final _$getCompanyAsyncAction =
      AsyncAction('_CompanyMyBranchesStore.getCompany');

  @override
  Future<String> getCompany() {
    return _$getCompanyAsyncAction.run(() => super.getCompany());
  }

  @override
  String toString() {
    return '''
company: ${company}
    ''';
  }
}
