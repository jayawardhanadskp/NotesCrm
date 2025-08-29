part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class AddCustomerLoading extends CustomerState {}

final class AddCustomerSuccess extends CustomerState {}

final class AddCustomerFailure extends CustomerState {
  final String error;
  AddCustomerFailure(this.error);
}

final class UpdateCustomerLoading extends CustomerState {}

final class UpdateCustomerSuccess extends CustomerState {}

final class UpdateCustomerFailure extends CustomerState {
  final String error;
  UpdateCustomerFailure(this.error);
}

final class LoadCustomersLoading extends CustomerState {}

final class LoadCustomersSuccess extends CustomerState {
  final List<CustomerModel> customers;
  LoadCustomersSuccess(this.customers);
}

final class LoadCustomersFailure extends CustomerState {
  final String error;
  LoadCustomersFailure(this.error);
}

final class LoadCustomerByIdLoading extends CustomerState {}

final class LoadCustomerByIdSuccess extends CustomerState {
  final CustomerModel customer;
  LoadCustomerByIdSuccess(this.customer);
}

final class LoadCustomerByIdFailure extends CustomerState {
  final String error;
  LoadCustomerByIdFailure(this.error);
}

final class DeleteCustomerLoading extends CustomerState {}

final class DeleteCustomerSuccess extends CustomerState {}

final class DeleteCustomerFailure extends CustomerState {
  final String error;
  DeleteCustomerFailure(this.error);
}
