part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final CustomerModel customer;

  AddCustomer(this.customer);
}

class UpdateCustomer extends CustomerEvent {
  final CustomerModel customer;
  UpdateCustomer(this.customer);
}

class LoadCustomers extends CustomerEvent {}

class LoadCustomerById extends CustomerEvent {
  final int customerId;
  LoadCustomerById(this.customerId);
}

class DeleteCustomer extends CustomerEvent {
  final int customerId;
  DeleteCustomer(this.customerId);
}
