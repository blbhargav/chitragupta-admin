import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/extension/Constants.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/product_model.dart';
import 'package:chitragupta/repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  final Repository repository;

  ProductBloc({this.repository}) : super(ProductInitial(showCity: false));
  List<City> cityList = new List();
  List<Category> categoryList=List();
  List<ProductModel> productsList=List();

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if(event is ProductInitEvent){
      if(Repository.user.type==Constants.superAdmin){
        yield ProductInitial(showCity: true);
      }else yield ProductInitial(showCity: false);
    }else if(event is FetchCitiesEvent){
      var snapshot=await repository.getCitiesOnce();
      List<City> tempCityList = new List();
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((element) {
          City city = City.fromSnapshot(snapshot: element);
          tempCityList.add(city);
        });
        cityList=tempCityList;
        yield LoadCitiesState(cityList: tempCityList);
      }else {
        yield LoadCitiesState(cityList: []);
      }
    }else if(event is AddProductEvent){
      yield ShowProgressState();
      try{
        print("BLB product ${event.name}, ${event.city}, ${event.cityID}, ${event.state}, ${event.categoryId}, ${event.category}");
        await repository.addProduct(event.name, event.city,event.cityID,event.state,event.categoryId,event.category);
        yield HideProgressState();
        yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }
    }else if(event is FetchProductsEvent){
      yield ShowProgressState();
      var products=await repository.getProductsOnce();
      productsList=products;
      yield HideProgressState();
      yield LoadProductsState(productList: products);
    }else if(event is FetchCategoriesEvent){
      yield ShowProgressState();
      var categories=await repository.getCategoriesOnce();
      categoryList=categories;
      yield HideProgressState();
      yield LoadCategoriesState(categoryList: categories);
    }else if(event is EditProductEvent){
      yield ShowProgressState();
      try{
        await repository.editProduct(event.id,event.name, event.cityID,event.city,event.state,event.categoryId,event.category,0);
        yield HideProgressState();
        yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }
    }else if(event is DeleteProductEvent){
      yield ShowProgressState();
      try{
        ProductModel product=event.product;
        await repository.editProduct(product.id,product.name, product.cityID,product.city,product.state ,product.categoryId,product.category,0);
        yield HideProgressState();
        yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }

    }
  }
}
