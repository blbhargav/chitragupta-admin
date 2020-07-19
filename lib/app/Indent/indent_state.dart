part of 'indent_bloc.dart';

@immutable
abstract class IndentState extends Equatable {
  @override
  List<Object> get props => [];
}

class IndentInitial extends IndentState {}

class ShowProgressState extends IndentState {}
class HideProgressState extends IndentState {}