// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_crm/blocs/customer/customer_bloc.dart';
import 'package:notes_crm/models/customer_model.dart';
import 'package:notes_crm/screens/widgets/app_button.dart';
import 'package:notes_crm/screens/widgets/app_snackbars.dart';
import 'package:notes_crm/screens/widgets/app_text_field.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final CustomerModel? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _companyController;

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
    _emailController = TextEditingController(
      text: widget.customer?.email ?? '',
    );
    _companyController = TextEditingController(
      text: widget.customer?.company ?? '',
    );
  }

  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final customer = CustomerModel(
        id: widget.customer?.id ?? null,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        company: _companyController.text.trim(),
        createdAt:
            widget.customer?.createdAt ?? DateTime.now().toIso8601String(),
      );

      final bloc = context.read<CustomerBloc>();

      if (isEditing) {
        bloc.add(UpdateCustomer(customer));
      } else {
        bloc.add(AddCustomer(customer));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is AddCustomerSuccess) {
          AppSnackbars.showSuccessSnackbar(
            context,
            'Customer added successfully',
          );

          Navigator.pop(context, true);
        } else if (state is UpdateCustomerSuccess) {
          AppSnackbars.showSuccessSnackbar(
            context,
            'Customer updated successfully',
          );

          Navigator.pop(context, true);
        } else if (state is AddCustomerFailure) {
          AppSnackbars.showErrorSnackbar(context, 'Add customer fail');
        } else if (state is UpdateCustomerFailure) {
          AppSnackbars.showErrorSnackbar(context, 'Update customer fail');
        }
      },
      builder: (context, state) {
        final isLoading = state is AddCustomerLoading;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            title: Text(
              isEditing ? 'Edit Customer' : 'Add Customer',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFF121212),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Name',
                      hintText: 'Kasun Pradeep',
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'Phone',
                      hintText: '+94 77 123 4567',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'name@domain.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _companyController,
                      labelText: 'Company',
                      hintText: 'ABC Pvt Ltd',
                    ),
                    const SizedBox(height: 54),
                    AppButton(
                      isLoading: isLoading,
                      handleLogin: _saveCustomer,
                      buttonText: isEditing
                          ? 'Update Customer'
                          : 'Add Customer',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
