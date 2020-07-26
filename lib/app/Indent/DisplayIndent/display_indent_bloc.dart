import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'display_indent_event.dart';
part 'display_indent_state.dart';

class DisplayIndentBloc extends Bloc<DisplayIndentEvent, DisplayIndentState> {
  Repository repository;
  String orderID;
  DisplayIndentBloc({this.repository,this.orderID}) : super(DisplayIndentInitial());

  @override
  Stream<DisplayIndentState> mapEventToState(
    DisplayIndentEvent event,
  ) async* {

  }
}
