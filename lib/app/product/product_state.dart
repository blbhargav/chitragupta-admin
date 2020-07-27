part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {
  final bool showCity;
  ProductInitial({this.showCity});
  @override
  List<Object> get props => [];
}

class CategoryInitial extends ProductState {
}

class LoadCitiesState extends ProductState {
  final List<City> cityList;
  LoadCitiesState({this.cityList});
}

class ShowProgressState extends ProductState {}

class HideProgressState extends ProductState {}

class AddingSuccessState extends ProductState {}

class AddingFailedState extends ProductState {}

class LoadProductsState extends ProductState {
  final List<ProductModel> productList;
  LoadProductsState({this.productList});
}

class LoadCategoriesState extends ProductState {
  final List<Category> categoryList;
  LoadCategoriesState({this.categoryList});
}