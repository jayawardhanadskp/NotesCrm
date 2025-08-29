// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_crm/models/customer_model.dart';
import 'package:notes_crm/repository/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  CustomerBloc(this.customerRepository) : super(CustomerInitial()) {
    on<AddCustomer>((event, emit) async {
      emit(AddCustomerLoading());
      try {
        await customerRepository.addCustomer(event.customer);
        emit(AddCustomerSuccess());
      } catch (e) {
        emit(AddCustomerFailure(e.toString()));
      }
    });

    on<LoadCustomerById>((event, emit) async {
      emit(LoadCustomerByIdLoading());
      try {
        final customer = await customerRepository.getCustomerById(
          event.customerId,
        );
        if (customer != null) {
          emit(LoadCustomerByIdSuccess(customer));
        } else {
          emit(LoadCustomerByIdFailure('Customer not found'));
        }
      } catch (e) {
        emit(LoadCustomerByIdFailure(e.toString()));
      }
    });

    on<UpdateCustomer>((event, emit) async {
      emit(UpdateCustomerLoading());
      try {
        await customerRepository.updateCustomer(event.customer);
        emit(UpdateCustomerSuccess());
      } catch (e) {
        emit(UpdateCustomerFailure(e.toString()));
      }
    });

    on<LoadCustomers>((event, emit) async {
      emit(LoadCustomersLoading());
      try {
        final customers = await customerRepository.getAllCustomers();
        emit(LoadCustomersSuccess(customers));
      } catch (e) {
        emit(LoadCustomersFailure(e.toString()));
      }
    });

    on<DeleteCustomer>((event, emit) async {
      emit(DeleteCustomerLoading());
      try {
        await customerRepository.deleteCustomer(event.customerId);
        emit(DeleteCustomerSuccess());
      } catch (e) {
        emit(DeleteCustomerFailure(e.toString()));
      }
    });
  }
}
