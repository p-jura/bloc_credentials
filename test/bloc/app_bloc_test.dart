import 'package:bloc_advanced/apis/login_api.dart';
import 'package:bloc_advanced/apis/notes_api.dart';
import 'package:bloc_advanced/bloc/app_bloc.dart';
import 'package:bloc_advanced/bloc/app_state.dart';
import 'package:bloc_advanced/models.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
  Note(title: 'Note 4'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.emty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '';

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return const LoginHandle.fooBar();
    } else {
      return null;
    }
  }
}

void main() {
  late final dummyLoginApi;
  late final dummyNotesApi;
  setUp(() {
    dummyLoginApi = const DummyLoginApi.empty();
    dummyNotesApi = const DummyNotesApi.emty();
  });
  blocTest<AppBloc, AppState>(
    'Initial state should be AppState.empty()',
    build: () => AppBloc(
      loginApi: dummyLoginApi,
      notesApi: dummyNotesApi,
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.emty(),
    ),
  );
}
