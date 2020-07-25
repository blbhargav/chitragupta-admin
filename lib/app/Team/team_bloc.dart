import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final Repository repository;

  TeamBloc({this.repository}) : super(CustomersInitial());
  List<City> cityList = new List();
  List<Member> customerList = new List();

  @override
  Stream<TeamState> mapEventToState(
    TeamEvent event,
  ) async* {
    if(event is FetchCitiesEvent){
      var snapshot=await repository.getCitiesOnce();
      List<City> tempCityList = new List();
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((element) {
          City city = City.fromSnapshot(snapshot: element);
          tempCityList.add(city);
        });
        cityList=tempCityList;
        yield LoadCitiesState(cityList: tempCityList);
      }else {
        yield LoadCitiesState(cityList: []);
      }
    }else if(event is AddMemberEvent){
      yield ShowProgressState();
      try{
        var result= await repository.addMember(event.name,event.type, event.mobile,event.email,event.address,event.cityID,event.city,event.state);
        yield HideProgressState();
        if(result.toString().contains("email-already-in-use")){
          yield EmailAlreadyInUseState();
        }else
          yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }
    }else if(event is FetchTeamMembersEvent){
      yield ShowProgressState();
      var members=await repository.getMembersOnce();
      customerList=members;
      yield HideProgressState();
      yield LoadTeamMembersState(teamList: members);
    }else if(event is EditTeamMembersEvent){
      yield ShowProgressState();
      try{
        await repository.editCustomer(event.userID,event.name, event.mobile,event.email,event.address,event.cityID,event.city,event.state);
        yield HideProgressState();
        yield AddingSuccessState();
      }catch(_e){
        yield HideProgressState();
        yield AddingFailedState();
      }
    }
  }
}
