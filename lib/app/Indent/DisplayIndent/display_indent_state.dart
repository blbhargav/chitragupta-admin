part of 'display_indent_bloc.dart';

@immutable
abstract class DisplayIndentState extends Equatable{
  @override
  List<Object> get props => [];
}

class DisplayIndentInitial extends DisplayIndentState {}

class LoadProductsState extends DisplayIndentState {
  final List<ProductModel> productList;
  LoadProductsState({this.productList});
}

class LoadCategoriesState extends DisplayIndentState {
  final List<Category> categoryList;
  LoadCategoriesState({this.categoryList});
}
class ShowProgressState extends DisplayIndentState {}

class HideProgressState extends DisplayIndentState {}

class AddingSuccessState extends DisplayIndentState {}

class AddingFailedState extends DisplayIndentState {}

class LoadTeamMembersState extends DisplayIndentState {
  final List<Member> teamList;
  LoadTeamMembersState({this.teamList});
}

class LoadIndentProductsState extends DisplayIndentState {
  final List<Indent> indentProductList;
  LoadIndentProductsState({this.indentProductList});
}

class ShowSpreadSheetImportState extends DisplayIndentState {}
class HideSpreadSheetImportState extends DisplayIndentState {}

class RefreshState extends DisplayIndentState {}