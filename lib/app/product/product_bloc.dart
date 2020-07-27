import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/extension/Constants.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/product.dart';
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
        await repository.editCategory(event.id,event.name, event.cityID,event.city,event.state);
        yield HideProgressState();
        yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }
    }
  }
}
