import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/extension/Constants.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.repository) : super(ProfileInitial());
  final Repository repository;
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if(event is ProfileInitialEvent){
      yield ProfileInitial();
      try{
        Member member= await repository.getProfile();
        yield DisplayProfileState(member);
        if(member.type==Constants.admin){

        }

      }catch(_e){
        yield NetworkErrorState();
      }

    }

  }
}
