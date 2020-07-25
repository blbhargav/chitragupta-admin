part of 'indent_bloc.dart';

@immutable
abstract class IndentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeStateEvent extends IndentEvent {
  //This event to change or reset present state.
}

class FetchOdersEvent extends IndentEvent {}

class FetchCitiesEvent extends IndentEvent {}

class FetchCustomersEvent extends IndentEvent {}

class CreateIndentButtonClickedEvent extends IndentEvent {}
class CreateIndentEvent extends IndentEvent {
  final DateTime orderDate;
  final String city;
  final String customer;
  CreateIndentEvent({this.customer,this.city,this.orderDate});
}

