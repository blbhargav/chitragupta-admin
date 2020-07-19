import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/repository.dart';
import 'package:equatable/equatable.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final Repository repository;

  CityBloc({this.repository}) : super(CityInitial());

  @override
  Stream<CityState> mapEventToState(
    CityEvent event,
  ) async* {
      if(event is InitStateEvent){
        yield CityInitial();
        var snapshot=await repository.getCitiesOnce();
        List<City> tempCityList = new List();
        if (snapshot.documents.length > 0) {
          var i = 0;
          snapshot.documents.forEach((element) {
            City city = City.fromSnapshot(snapshot: element);
            tempCityList.add(city);
          });
          yield DisplayDataState(cityList: tempCityList);
        }else {
          yield DataNotFoundState();
        }

//        repository.getCitiesOnce().then((value) async*{
//          List<City> tempCityList = new List();
//          if (value.documents.length > 0) {
//            var i = 0;
//            value.documents.forEach((element) {
//              City city = City.fromSnapshot(snapshot: element);
//              tempCityList.add(city);
//            });
//          }
//          yield DisplayDataState();
//        });
      }else if(event is AddCityEvent){
        yield ShowProgressState();
        try{
          await repository.addCity(event.city, event.state);
          yield HideProgressState();
          yield AddingSuccessState();
        }catch(_e){
          yield HideProgressState();
          yield AddingFailedState();
        }

      }
  }
}
