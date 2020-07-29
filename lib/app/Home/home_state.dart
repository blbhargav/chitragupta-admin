part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class ShowProgressState extends HomeState {}

class HideProgressState extends HomeState {}

class ShowDashboardState extends HomeState {}
class ShowIndentState extends HomeState {}
class ShowExpensesState extends HomeState {}
class ShowAnalyticsState extends HomeState {}
class ShowHistoryState extends HomeState {}
class ShowSettingsState extends HomeState {}
class ShowCitiesState extends HomeState {}
class ShowCustomersState extends HomeState {}
class ShowTeamState extends HomeState {}
class ShowCategoryState extends HomeState {}
class ShowProductsState extends HomeState {}
class ShowAboutState extends HomeState {}
class DisplayIndentState extends HomeState {
  final Order order;
  DisplayIndentState(this.order);
}

class DisplayExpenseState extends HomeState {
  final Order order;
  DisplayExpenseState(this.order);
}