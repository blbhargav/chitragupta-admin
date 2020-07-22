part of 'team_bloc.dart';

@immutable
abstract class TeamEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class InitStateEvent extends TeamEvent {}

class FetchCitiesEvent extends TeamEvent {}

class AddMemberEvent extends TeamEvent {
  final String name,type, mobile, email,address, city,state,cityID;
  AddMemberEvent({this.city,this.state,this.email,this.name,this.address,this.cityID,this.mobile,this.type});
}

class FetchTeamMembersEvent extends TeamEvent{}

class EditTeamMembersEvent extends TeamEvent {
  final String name,type, mobile, email,address, city,state,cityID,userID;
  EditTeamMembersEvent({this.city,this.state,this.email,this.name,this.address,this.cityID,this.mobile,this.userID,this.type});
}