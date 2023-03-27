import 'package:bloc_advanced/apis/login_api.dart';
import 'package:bloc_advanced/apis/notes_api.dart';
import 'package:bloc_advanced/bloc/actions.dart';
import 'package:bloc_advanced/bloc/app_bloc.dart';
import 'package:bloc_advanced/bloc/app_state.dart';
import 'package:bloc_advanced/dialogs/generic_dialogs.dart';
import 'package:bloc_advanced/dialogs/loading_screen.dart';
import 'package:bloc_advanced/models.dart';
import 'package:bloc_advanced/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/iterable_list_view.dart';

import 'constants.dart';

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
        appBar: AppBar(title: const Text(homePage)),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                ctx: context,
                txt: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: logingErrorDialogTitle,
                content: logingErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadingNotesAction(),
                  );
            }
          },
          builder: (ctx, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  ctx.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            }
            return notes.toListView();
          },
        ),
      ),
    );
  }
}
