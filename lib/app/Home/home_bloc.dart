import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final Repository repository;

  HomeBloc({this.repository}) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
      if(event is ChangeStateEvent || event is DashboardItemClickedEvent){
        yield HomeInitial();
      }else if(event is IndentItemClickedEvent){
        yield ShowIndentState();
      }else if(event is ExpensesItemClickedEvent){
        yield ShowExpensesState();
      }else if(event is AnalyticsItemClickedEvent){
        yield ShowAnalyticsState();
      }else if(event is HistoryItemClickedEvent){
        yield ShowHistoryState();
      }else if(event is SettingsClickedEvent){
        yield ShowSettingsState();
      }else if(event is AboutItemClickedEvent){
        yield ShowAboutState();
      }else if(event is CitiesItemClickedEvent){
        yield ShowCitiesState();
      }else if(event is CustomersItemClickedEvent){
        yield ShowCustomersState();
      }else if(event is TeamItemClickedEvent){
        yield ShowTeamState();
      }else if(event is DisplayIndentClickedEvent){
        yield DisplayIndentState(event.order);
      }else if(event is DisplayExpenseClickedEvent){
        yield DisplayExpenseState(event.order);
      }else if(event is CategoryItemClickedEvent){
        yield ShowCategoryState();
      }else if(event is ProductsClickedEvent){
        yield ShowProductsState();
      }else if(event is ProfileClickedEvent){
        yield ShowProfileState();
      }
  }
}
