part of 'expenses_bloc.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();
  @override
  List<Object> get props => [];
}

class ChangeStateEvent extends ExpensesEvent {
  //This event to change or reset present state.
}

class FetchOdersEvent extends ExpensesEvent {}

class FetchCitiesEvent extends ExpensesEvent {}

class FetchCustomersEvent extends ExpensesEvent {}

class CreateIndentButtonClickedEvent extends ExpensesEvent {}
class CreateIndentEvent extends ExpensesEvent {
  final DateTime orderDate;
  final String city;
  final String customer;
  CreateIndentEvent({this.customer,this.city,this.orderDate});
}
