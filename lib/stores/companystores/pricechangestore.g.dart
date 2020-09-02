// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricechangestore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PriceChangeStore on _PriceChangeStore, Store {
  final _$productsAtom = Atom(name: '_PriceChangeStore.products');

  @override
  List<ProductPrice> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(List<ProductPrice> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  final _$getProductsAsyncAction = AsyncAction('_PriceChangeStore.getProducts');

  @override
  Future<String> getProducts() {
    return _$getProductsAsyncAction.run(() => super.getProducts());
  }

  final _$priceChangeAsyncAction = AsyncAction('_PriceChangeStore.priceChange');

  @override
  Future<String> priceChange(
      String id, String productId, dynamic price, String password) {
    return _$priceChangeAsyncAction
        .run(() => super.priceChange(id, productId, price, password));
  }

  @override
  String toString() {
    return '''
products: ${products}
    ''';
  }
}
