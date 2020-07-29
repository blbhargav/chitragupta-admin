part of 'expenses_bloc.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();
  @override
  List<Object> get props => [];
}

class ExpensesInitial extends ExpensesState {
  @override
  List<Object> get props => [];
}

class IndentInitial extends ExpensesState {}

class InitialLoadingState extends ExpensesState {}

class ShowProgressState extends ExpensesState {}
class HideProgressState extends ExpensesState {}

class LoadCitiesState extends ExpensesState {
  final List<City> cityList;
  LoadCitiesState({this.cityList});
}

class LoadCustomersState extends ExpensesState {
  final List<Customer> customersList;
  LoadCustomersState({this.customersList});
}
class ShowCreateIndentState extends ExpensesState {
  final String error;
  ShowCreateIndentState({this.error});
}

class DisplayOrdersState extends ExpensesState {
  final List<Order> ordersList;
  DisplayOrdersState({this.ordersList});
}

class ResetFormState extends ExpensesState {}
