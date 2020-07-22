part of 'team_bloc.dart';

@immutable
abstract class TeamState extends Equatable{
  @override
  List<Object> get props => [];
}

class CustomersInitial extends TeamState {}

class DataNotFoundState extends TeamState {}

class DisplayDataState extends TeamState {
//  final List<City> cityList;
//  DisplayDataState({this.cityList});
}
class LoadCitiesState extends TeamState {
  final List<City> cityList;
  LoadCitiesState({this.cityList});
}

class ShowProgressState extends TeamState {}

class HideProgressState extends TeamState {}

class AddingSuccessState extends TeamState {}

class AddingFailedState extends TeamState {}

class LoadTeamMembersState extends TeamState {
  final List<Customer> teamList;
  LoadTeamMembersState({this.teamList});
}

class EmailAlreadyInUseState extends TeamState {}