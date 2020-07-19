part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}
class ChangeStateEvent extends HomeEvent {
  //This event to change or reset present state.
}
class SuccessAlertFinishEvent extends HomeEvent{}

class DashboardItemClickedEvent extends HomeEvent{}

class IndentItemClickedEvent extends HomeEvent{}

class ExpensesItemClickedEvent extends HomeEvent{}

class AnalyticsItemClickedEvent extends HomeEvent{}

class SettingsClickedEvent extends HomeEvent{}

class HistoryItemClickedEvent extends HomeEvent{}

class AboutItemClickedEvent extends HomeEvent{}
class CitiesItemClickedEvent extends HomeEvent{}
class CustomersItemClickedEvent extends HomeEvent{}
class TeamItemClickedEvent extends HomeEvent{}
class LogoutItemClickedEvent extends HomeEvent{}