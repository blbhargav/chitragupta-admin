part of 'customers_bloc.dart';

@immutable
abstract class CustomersEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class InitStateEvent extends CustomersEvent {}

class FetchCitiesEvent extends CustomersEvent {}

class AddCustomerEvent extends CustomersEvent {
  final String name, mobile, email,address, city,state,cityID;
  AddCustomerEvent({this.city,this.state,this.email,this.name,this.address,this.cityID,this.mobile});
}

class FetchCustomersEvent extends CustomersEvent{}

class EditCustomerEvent extends CustomersEvent {
  final String name, mobile, email,address, city,state,cityID,customerID;
  EditCustomerEvent({this.city,this.state,this.email,this.name,this.address,this.cityID,this.mobile,this.customerID});
}