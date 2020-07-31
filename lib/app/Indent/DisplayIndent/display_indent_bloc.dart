import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/extension/util.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/indent.dart';
import 'package:chitragupta/models/product.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

part 'display_indent_event.dart';
part 'display_indent_state.dart';

class DisplayIndentBloc extends Bloc<DisplayIndentEvent, DisplayIndentState> {
  Repository repository;
  Order order;
  DisplayIndentBloc({this.repository,this.order}) : super(DisplayIndentInitial());

  List<Category> categoryList=List();
  List<ProductModel> productsList=List();
  List<Member> teamList = new List();
  List<Product> indentList=List();

  @override
  Stream<DisplayIndentState> mapEventToState(DisplayIndentEvent event,) async* {
    if(event is FetchIndentProductsEvent){
      yield DisplayIndentInitial();
      var products=await repository.getIndentProducts(order.orderId);
      indentList=products;
      yield HideProgressState();
      yield LoadIndentProductsState(indentProductList: products);
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
    }else if(event is FetchTeamMembersEvent){
      yield ShowProgressState();
      var members=await repository.getEmployeesOnceByCity(order.cityID);
      teamList=members;
      yield HideProgressState();
      yield LoadTeamMembersState(teamList: members);
    }else if(event is AddIndentProductEvent){
      yield ShowProgressState();
      await repository.addIndentProduct(event.indent);
      yield HideProgressState();
      yield AddingSuccessState();
    }else if(event is ImportFromExcelEvent){
      yield ShowSpreadSheetImportState();
      SpreadsheetTable table=event.table;
      var createdDate=DateTime.now().millisecondsSinceEpoch;
      for(int i=1;i<table.rows.length;i++){
        var data=table.rows[i];
        var indent=Product(orderId: order.orderId,createdDate: createdDate,purchaseOrderQty: 0,purchaseQty: 0);

        if(data[0]!=null){
          indent.product=data[0];
          for(int j=0;j<productsList.length;j++){
            if(data[0]==productsList[j].name){
              indent.category=productsList[j].category;
              indent.categoryId=productsList[j].categoryId;
              indent.productId=productsList[j].id;
              break;
            }
          }

          if(data[1]!=null && Utils.isValidNumber("${data[1]}")){
            indent.purchaseOrderQty=data[1];
          }

          if(data[2]!=null && Utils.isValidNumber("${data[2]}")){
            indent.purchaseQty=data[2];
          }

          if(data[3]!=null){
            for(int j=0;j<teamList.length;j++){
              if(data[3]==teamList[j].name){
                indent.employee=teamList[j].name;
                indent.employeeId=teamList[j].uid;
                break;
              }
            }
          }
          await repository.addIndentProduct(indent);
        }
      }

      yield HideSpreadSheetImportState();
    }else if(event is UpdateIndentProductsEvent){
      yield ShowProgressState();
      await repository.updateProductInOrder(order.orderId, event.product);
      yield HideProgressState();
      yield RefreshState();
    }else if(event is DeleteIndentProductsEvent){
      yield ShowProgressState();
      await repository.removeProductFromOrder(order.orderId, event.product.id);
      yield HideProgressState();
      yield RefreshState();
    }

  }

}
