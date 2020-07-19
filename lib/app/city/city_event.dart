part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();
  @override
  List<Object> get props => [];
}

class ChangeStateEvent extends CityEvent {
  //This event to change or reset present state.
}

class InitStateEvent extends CityEvent {}

class AddCityEvent extends CityEvent {
  final String city, state;
  AddCityEvent({this.city,this.state});
}