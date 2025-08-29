import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_crm/blocs/customer/customer_bloc.dart';
import 'package:notes_crm/blocs/note/note_bloc.dart';
import 'package:notes_crm/repository/customer_repository.dart';
import 'package:notes_crm/repository/note_repository.dart';
import 'package:notes_crm/screens/login_screen.dart';
import 'package:notes_crm/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => CustomerRepository()),
        RepositoryProvider(create: (_) => NoteRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CustomerBloc(CustomerRepository())),
          BlocProvider(create: (_) => NoteBloc(NoteRepository())),
        ],
        child: MaterialApp(
          title: 'CRM Mobile',
          theme: AppTheme.darkTheme,
          home: const LoginScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
