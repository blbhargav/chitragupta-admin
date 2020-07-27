import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/product.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'display_indent_event.dart';
part 'display_indent_state.dart';

class DisplayIndentBloc extends Bloc<DisplayIndentEvent, DisplayIndentState> {
  Repository repository;
  String orderID;
  DisplayIndentBloc({this.repository,this.orderID}) : super(DisplayIndentInitial());

  List<Category> categoryList=List();
  List<ProductModel> productsList=List();
  List<Member> teamList = new List();

  @override
  Stream<DisplayIndentState> mapEventToState(DisplayIndentEvent event,) async* {
    if(event is FetchProductsEvent){
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
    }else if(event is FetchTeamMembersEvent){
      yield ShowProgressState();
      var members=await repository.getMembersOnce();
      teamList=members;
      yield HideProgressState();
      yield LoadTeamMembersState(teamList: members);
    }
  }
}
