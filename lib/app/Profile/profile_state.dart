part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ShowProgressState extends ProfileState {}

class HideProgressState extends ProfileState {}

class NetworkErrorState extends ProfileState {}

class DisplayProfileState extends ProfileState {
  final Member member;
  DisplayProfileState(this.member);
}