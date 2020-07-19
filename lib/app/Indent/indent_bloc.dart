import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'indent_event.dart';
part 'indent_state.dart';

class IndentBloc extends Bloc<IndentEvent, IndentState> {
  Repository repository;
  IndentBloc({this.repository}) : super(IndentInitial());

  @override
  Stream<IndentState> mapEventToState(
    IndentEvent event,
  ) async* {

  }
}
