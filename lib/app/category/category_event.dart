part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object> get props => [];
}
class FetchCitiesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String name, city,state,cityID;
  AddCategoryEvent({this.city,this.state,this.name,this.cityID});
}

class FetchCategoriesEvent extends CategoryEvent{}

class EditCategoryEvent extends CategoryEvent {
  final String name, city,state,cityID,id;
  EditCategoryEvent({this.city,this.state,this.cityID,this.name,this.id});
}
