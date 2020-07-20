import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final Repository repository;

  CustomersBloc({this.repository}) : super(CustomersInitial());
  List<City> cityList = new List();

  @override
  Stream<CustomersState> mapEventToState(
    CustomersEvent event,
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
    }else if(event is AddCustomerEvent){
      yield ShowProgressState();
      try{
        await repository.addCustomer(event.name, event.mobile,event.email,event.address,event.cityID,event.city,event.state);
        yield HideProgressState();
        yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }
    }
  }
}
