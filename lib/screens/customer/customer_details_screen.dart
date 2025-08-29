import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_crm/blocs/customer/customer_bloc.dart';
import 'package:notes_crm/blocs/note/note_bloc.dart';
import 'package:notes_crm/models/customer_model.dart';
import 'package:notes_crm/screens/customer/add_edit_customer_screen.dart';
import 'package:notes_crm/screens/dashboard_screen.dart';
import 'package:notes_crm/screens/notes/add_note_screen.dart';
import 'package:notes_crm/screens/widgets/app_snackbars.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.customer.id != null) {
      context.read<CustomerBloc>().add(LoadCustomerById(widget.customer.id!));
      context.read<NoteBloc>().add(LoadNotesForCustomer(widget.customer.id!));
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  String _formatDate(String createdAt) {
    final date = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, customerState) {
        if (customerState is DeleteCustomerSuccess) {
          AppSnackbars.showSuccessSnackbar(
            context,
            'Customer deleted successfully',
          );
          Navigator.of(context).pop();
        } else if (customerState is DeleteCustomerFailure) {
          AppSnackbars.showErrorSnackbar(
            context,
            'Failed to delete customer: ${customerState.error}',
          );
        }
      },
      builder: (context, customerState) {
        if (customerState is LoadCustomerByIdLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (customerState is LoadCustomerByIdFailure) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF121212),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<CustomerBloc>().add(LoadCustomers());
                },
              ),
            ),
            body: Center(
              child: Text(
                'Error: ${customerState.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        final customer = customerState is LoadCustomerByIdSuccess
            ? customerState.customer
            : widget.customer;

        return Scaffold(
          appBar: AppBar(
            title: Text(customer.name),
            backgroundColor: const Color(0xFF121212),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CustomerBloc>().add(LoadCustomers());
              },
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _editCustomer(customer);
                  } else if (value == 'delete') {
                    _deleteCustomer(customer);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFC107),
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                _getInitials(customer.name),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            customer.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFC107),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                customer.company.isNotEmpty
                                    ? customer.company
                                    : customer.email.isNotEmpty
                                    ? customer.email
                                    : customer.phone.isNotEmpty
                                    ? customer.phone
                                    : 'No contact info',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _contactInfo(
                        Icons.phone,
                        customer.phone.isNotEmpty ? customer.phone : 'No phone',
                      ),
                      const SizedBox(height: 20),
                      _contactInfo(
                        Icons.email,
                        customer.email.isNotEmpty ? customer.email : 'No email',
                      ),
                      const SizedBox(height: 20),
                      _contactInfo(
                        Icons.business,
                        customer.company.isNotEmpty
                            ? customer.company
                            : 'No company',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          BlocBuilder<NoteBloc, NoteState>(
                            builder: (context, state) {
                              int noteCount = 0;
                              if (state is LoadNotesForCustomerSuccess) {
                                noteCount = state.notes.length;
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E2E2E),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$noteCount',
                                  style: const TextStyle(
                                    color: Color(0xFFFFC107),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () => _addNote(customer),
                        icon: const Icon(Icons.add, color: Color(0xFFFFC107)),
                        label: const Text(
                          'Add Note',
                          style: TextStyle(color: Color(0xFFFFC107)),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<NoteBloc, NoteState>(
                  listener: (context, state) {
                    if (state is AddNoteSuccess) {
                      if (customer.id != null) {
                        context.read<NoteBloc>().add(
                          LoadNotesForCustomer(customer.id!),
                        );
                        AppSnackbars.showSuccessSnackbar(
                          context,
                          'Note added successfully',
                        );
                      }
                    } else if (state is AddNoteError) {
                      AppSnackbars.showErrorSnackbar(
                        context,
                        'Error: ${state.message}',
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadNotesForCustomerLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LoadNotesForCustomerError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    } else if (state is LoadNotesForCustomerSuccess) {
                      final notes = state.notes;
                      if (notes.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.note_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No notes yet',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first note to see lists',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Card(
                            color: const Color(0xFF1E1E1E),
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFFFC107),
                                child: Icon(Icons.note, color: Colors.black),
                              ),
                              title: Text(
                                note.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    note.description,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatDate(note.createdAt),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _contactInfo(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFFD700)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editCustomer(CustomerModel customer) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AddEditCustomerScreen(customer: customer),
          ),
        )
        .then((_) {
          if (customer.id != null && mounted) {
            context.read<CustomerBloc>().add(LoadCustomerById(customer.id!));
          }
        });
  }

  void _deleteCustomer(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Delete Customer',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete ${customer.name}?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (customer.id != null) {
                  context.read<CustomerBloc>().add(
                    DeleteCustomer(customer.id!),
                  );
                  if (mounted) {
                    context.read<CustomerBloc>().add(LoadCustomers());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addNote(CustomerModel customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(customer: customer),
      ),
    );
  }
}
