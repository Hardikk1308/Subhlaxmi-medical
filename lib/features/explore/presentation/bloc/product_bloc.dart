import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/explore/domain/usecases/get_products_usecase.dart';
import 'package:mediecom/features/explore/domain/usecases/get_product_details_usecase.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

// Events
abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final String? categoryId;
  FetchProducts({this.categoryId});
}

class FetchProductDetails extends ProductEvent {
  final String productCode;
  FetchProductDetails({required this.productCode});
}

class FetchProductDetailsByCategory extends ProductEvent {
  final String productCode;
  final String categoryId;
  FetchProductDetailsByCategory({
    required this.productCode,
    required this.categoryId,
  });
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  ProductLoaded({required this.products});
}

class ProductDetailsLoading extends ProductState {}

class ProductDetailsLoaded extends ProductState {
  final ProductEntity product;
  ProductDetailsLoaded({required this.product});
}

class ProductFailure extends ProductState {
  final String message;
  ProductFailure({required this.message});
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.getProductDetailsUseCase,
  }) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchProductDetails>(_onFetchProductDetails);
    on<FetchProductDetailsByCategory>(_onFetchProductDetailsByCategory);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProductsUseCase.call(categoryId: event.categoryId);
    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> _onFetchProductDetails(
    FetchProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    appLog('ProductBloc._onFetchProductDetails - Starting for productCode: ${event.productCode}');
    emit(ProductDetailsLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    final result = await getProductDetailsUseCase.call(
      productCode: event.productCode,
    );
    result.fold(
      (failure) {
        appLog('ProductBloc._onFetchProductDetails - Failure: ${failure.message}');
        emit(ProductFailure(message: failure.message));
      },
      (product) {
        appLog('ProductBloc._onFetchProductDetails - Success');
        appLog('ProductBloc._onFetchProductDetails - Product M1_CODE: ${product.M1_CODE}');
        appLog('ProductBloc._onFetchProductDetails - Product M1_ADD1 length: ${product.M1_ADD1?.length ?? 0}');
        final preview = product.M1_ADD1 != null 
          ? product.M1_ADD1!.substring(0, (product.M1_ADD1!.length < 100 ? product.M1_ADD1!.length : 100))
          : 'null';
        appLog('ProductBloc._onFetchProductDetails - Product M1_ADD1 first 100 chars: $preview');
        emit(ProductDetailsLoaded(product: product));
      },
    );
  }

  Future<void> _onFetchProductDetailsByCategory(
    FetchProductDetailsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductDetailsLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    final result = await getProductDetailsUseCase.callByCategory(
      productCode: event.productCode,
      categoryId: event.categoryId,
    );
    result.fold(
      (failure) => emit(ProductFailure(message: failure.message)),
      (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }
}
