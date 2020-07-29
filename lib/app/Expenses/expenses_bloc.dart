import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/repository.dart';
import 'package:equatable/equatable.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc({this.repository}) : super(ExpensesInitial());

  Repository repository;

  @override
  Stream<ExpensesState> mapEventToState(
    ExpensesEvent event,
  ) async* {
    if(event is FetchOdersEvent){
      yield InitialLoadingState();
      var orders=await repository.getActiveIndents();
      yield HideProgressState();
      yield DisplayOrdersState(ordersList: orders);
    }
  }
}
