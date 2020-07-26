part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {
}

class LoadCitiesState extends CategoryState {
  final List<City> cityList;
  LoadCitiesState({this.cityList});
}

class ShowProgressState extends CategoryState {}

class HideProgressState extends CategoryState {}

class AddingSuccessState extends CategoryState {}

class AddingFailedState extends CategoryState {}

class LoadCategoriesState extends CategoryState {
  final List<Category> categoryList;
  LoadCategoriesState({this.categoryList});
}
