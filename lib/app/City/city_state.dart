part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();
  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class DataNotFoundState extends CityState {}

class DisplayDataState extends CityState {
  final List<City> cityList;
  DisplayDataState({this.cityList});
}

class ShowProgressState extends CityState {}

class HideProgressState extends CityState {}

class AddingSuccessState extends CityState {}

class AddingFailedState extends CityState {}
