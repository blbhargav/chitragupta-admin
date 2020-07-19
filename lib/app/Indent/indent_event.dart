part of 'indent_bloc.dart';

@immutable
abstract class IndentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeStateEvent extends IndentEvent {
  //This event to change or reset present state.
}
