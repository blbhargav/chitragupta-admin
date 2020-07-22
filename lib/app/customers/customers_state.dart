part of 'customers_bloc.dart';

@immutable
abstract class CustomersState extends Equatable{
  @override
  List<Object> get props => [];
}

class CustomersInitial extends CustomersState {}

class DataNotFoundState extends CustomersState {}

class DisplayDataState extends CustomersState {
//  final List<City> cityList;
//  DisplayDataState({this.cityList});
}
class LoadCitiesState extends CustomersState {
  final List<City> cityList;
  LoadCitiesState({this.cityList});
}

class ShowProgressState extends CustomersState {}

class HideProgressState extends CustomersState {}

class AddingSuccessState extends CustomersState {}

class AddingFailedState extends CustomersState {}

class LoadCustomersState extends CustomersState {
  final List<Customer> customerList;
  LoadCustomersState({this.customerList});
}