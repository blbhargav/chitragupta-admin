part of 'indent_bloc.dart';

@immutable
abstract class IndentState extends Equatable {
  @override
  List<Object> get props => [];
}

class IndentInitial extends IndentState {}

class InitialLoadingState extends IndentState {}

class ShowProgressState extends IndentState {}
class HideProgressState extends IndentState {}

class LoadCitiesState extends IndentState {
  final List<City> cityList;
  LoadCitiesState({this.cityList});
}

class LoadCustomersState extends IndentState {
  final List<Customer> customersList;
  LoadCustomersState({this.customersList});
}
class ShowCreateIndentState extends IndentState {
  final String error;
  ShowCreateIndentState({this.error});
}

class DisplayOrdersState extends IndentState {
  final List<Order> ordersList;
  DisplayOrdersState({this.ordersList});
}

class ResetFormState extends IndentState {}