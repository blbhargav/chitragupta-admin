import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'indent_event.dart';
part 'indent_state.dart';

class IndentBloc extends Bloc<IndentEvent, IndentState> {
  Repository repository;
  IndentBloc({this.repository}) : super(IndentInitial());

  List<City> cityList = new List();
  List<Customer> customerList = new List();

  @override
  Stream<IndentState> mapEventToState(
    IndentEvent event,
  ) async* {
    if(event is FetchOdersEvent){
      yield InitialLoadingState();
      var orders=await repository.getActiveIndents();
      yield HideProgressState();
      yield DisplayOrdersState(ordersList: orders);
    }else if(event is FetchCitiesEvent){
      if(Repository.user.type=="SuperAdmin"){
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
      }else{
        yield IndentInitial();
      }

    }else if(event is FetchCustomersEvent){
      List<Customer> tempCityList=await repository.getCustomersOnce();
      customerList=tempCityList;
      yield LoadCustomersState(customersList: customerList);
    }else if(event is ChangeStateEvent){
      yield IndentInitial();
    }else if(event is CreateIndentButtonClickedEvent){
      yield ShowCreateIndentState(error: "");
    }else if(event is CreateIndentEvent){
      if(Repository.user.type=="SuperAdmin"){
        if(event.city=="Select City"){
          yield ShowCreateIndentState(error: "Please select city");
        }else if(event.customer=="Select Customer"){
          yield ShowCreateIndentState(error: "Please select customer");
        }else{
          yield ShowProgressState();
          Customer customer;
          customerList.forEach((element) {
            if(element.name==event.customer){
              customer=element;
            }
          });
          await repository.createIndent(customer, event.orderDate);
          var orders=await repository.getActiveIndents();
          yield HideProgressState();
          yield DisplayOrdersState(ordersList: orders);
        }
        yield ResetFormState();
      }
    }

  }
}
