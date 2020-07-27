import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final Repository repository;

  CategoryBloc({this.repository}) : super(CategoryInitial());
  List<City> cityList = new List();
  List<Category> categoryList=List();
  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if(event is FetchCitiesEvent){
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
    }else if(event is AddCategoryEvent){
      yield ShowProgressState();
      try{
      await repository.addCategory(event.name, event.city,event.cityID,event.state);
      yield HideProgressState();
      yield AddingSuccessState();
      }catch(_e){
      yield HideProgressState();
      yield AddingFailedState();
      }
    }else if(event is FetchCategoriesEvent){
      yield ShowProgressState();
      var categories=await repository.getCategoriesOnce();
      categoryList=categories;
      yield HideProgressState();
      yield LoadCategoriesState(categoryList: categories);
    }else if(event is EditCategoryEvent){
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
