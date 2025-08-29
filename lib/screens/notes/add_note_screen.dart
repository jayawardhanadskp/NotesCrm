import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_crm/blocs/note/note_bloc.dart';
import 'package:notes_crm/models/customer_model.dart';
import 'package:notes_crm/models/note_model.dart';
import 'package:notes_crm/screens/widgets/app_button.dart';
import 'package:notes_crm/screens/widgets/app_text_field.dart';
import 'package:notes_crm/screens/widgets/app_snackbars.dart';

class AddNoteScreen extends StatefulWidget {
  final CustomerModel? customer;

  const AddNoteScreen({super.key, this.customer});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final note = NoteModel(
        id: null,
        customerId: widget.customer!.id!,
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now().toIso8601String(),
      );
      context.read<NoteBloc>().add(AddNote(note));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is AddNoteSuccess) {
          AppSnackbars.showSuccessSnackbar(context, 'Note added successfully');
          Navigator.pop(context);
        } else if (state is AddNoteError) {
          AppSnackbars.showErrorSnackbar(context, 'Error: ${state.message}');
        }
      },
      builder: (context, state) {
        final isLoading = state is AddNoteLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Note',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFF121212),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.customer != null) ...[
                    Text(
                      'Customer ${widget.customer!.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  AppTextField(
                    controller: _titleController,
                    labelText: 'Title',
                    hintText: 'Note title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    hintText: 'Enter note details...',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 44),
                  AppButton(
                    isLoading: isLoading,
                    handleLogin: _handleSave,
                    buttonText: 'Save Note',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
