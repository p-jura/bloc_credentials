import 'package:bloc/bloc.dart';
import 'package:bloc_advanced/apis/login_api.dart';
import 'package:bloc_advanced/apis/notes_api.dart';
import 'package:bloc_advanced/bloc/actions.dart';
import 'package:bloc_advanced/bloc/app_state.dart';
import 'package:bloc_advanced/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.emty()) {
    on<LoginAction>(
      (event, emit) async {
        emit(
          const AppState(
            isLoading: true,
            fetchedNotes: null,
            loginError: null,
            loginHandle: null,
          ),
        );
        final loginHandle =
            await loginApi.login(email: event.email, password: event.password);
        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );
    on<LoadingNotesAction>(
      (event, emit) async {
        // start loading
        emit(
          AppState(
            isLoading: true,
            fetchedNotes: null,
            loginError: null,
            loginHandle: state.loginHandle,
          ),
        );
        final loginHandle = state.loginHandle;
        // invalid loging handle
        if (loginHandle != const LoginHandle.fooBar()) {
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        //valid login handle
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
