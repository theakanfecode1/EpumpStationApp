// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expensestore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ExpenseStore on _ExpenseStore, Store {
  final _$expensesAtom = Atom(name: '_ExpenseStore.expenses');

  @override
  List<Expense> get expenses {
    _$expensesAtom.reportRead();
    return super.expenses;
  }

  @override
  set expenses(List<Expense> value) {
    _$expensesAtom.reportWrite(value, super.expenses, () {
      super.expenses = value;
    });
  }

  final _$totalExpensesAtom = Atom(name: '_ExpenseStore.totalExpenses');

  @override
  dynamic get totalExpenses {
    _$totalExpensesAtom.reportRead();
    return super.totalExpenses;
  }

  @override
  set totalExpenses(dynamic value) {
    _$totalExpensesAtom.reportWrite(value, super.totalExpenses, () {
      super.totalExpenses = value;
    });
  }

  final _$getExpensesAsyncAction = AsyncAction('_ExpenseStore.getExpenses');

  @override
  Future<String> getExpenses(String startDate, String endDate) {
    return _$getExpensesAsyncAction
        .run(() => super.getExpenses(startDate, endDate));
  }

  @override
  String toString() {
    return '''
expenses: ${expenses},
totalExpenses: ${totalExpenses}
    ''';
  }
}
