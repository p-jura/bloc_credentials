import 'package:bloc/bloc.dart';
import 'package:bloc_advanced/apis/login_api.dart';
import 'package:bloc_advanced/apis/notes_api.dart';
import 'package:bloc_advanced/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main(List<String> args) {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi.instance(),
        notesApi: NotesApi.instance(),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('')),
        body: Container(),
      ),
    );
  }
}
