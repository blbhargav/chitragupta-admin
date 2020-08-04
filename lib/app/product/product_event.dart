part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}
class ProductInitEvent extends ProductEvent {}
class FetchCitiesEvent extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String name, city,state,cityID,categoryId,category;
  AddProductEvent({this.city,this.state,this.name,this.cityID,this.category,this.categoryId});
}

class FetchProductsEvent extends ProductEvent{}

class EditProductEvent extends ProductEvent {
  final String name, city,state,cityID,id,categoryId,category;
  EditProductEvent({this.city,this.state,this.cityID,this.name,this.id,this.category,this.categoryId});
}

class FetchCategoriesEvent extends ProductEvent{}

class DeleteProductEvent extends ProductEvent{
  final ProductModel product;
  DeleteProductEvent(this.product);
}