part of 'display_indent_bloc.dart';

@immutable
abstract class DisplayIndentEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class FetchCategoriesEvent extends DisplayIndentEvent{}
class FetchProductsEvent extends DisplayIndentEvent{}
class FetchTeamMembersEvent extends DisplayIndentEvent{}