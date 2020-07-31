part of 'display_indent_bloc.dart';

@immutable
abstract class DisplayIndentEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class FetchCategoriesEvent extends DisplayIndentEvent{}
class FetchProductsEvent extends DisplayIndentEvent{}
class FetchTeamMembersEvent extends DisplayIndentEvent{

}

class AddIndentProductEvent extends DisplayIndentEvent{
  final Product indent;
  AddIndentProductEvent({this.indent});
}

class FetchIndentProductsEvent extends DisplayIndentEvent{
  final String orderId;
  FetchIndentProductsEvent({this.orderId});
}

class ImportFromExcelEvent extends DisplayIndentEvent{
  final SpreadsheetTable table;
  ImportFromExcelEvent(this.table);
}

class UpdateIndentProductsEvent extends DisplayIndentEvent{
  final Product product;
  UpdateIndentProductsEvent({this.product});
}

class DeleteIndentProductsEvent extends DisplayIndentEvent{
  final Product product;
  DeleteIndentProductsEvent({this.product});
}