import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.login(event.email, event.password);

      if (response != null && response['user'] != null) {
        try {
          final user = User.fromJson(response['user']);
          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(AuthError('Failed to process user data'));
        }
      } else {
        emit(AuthError('Invalid response from server'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.register(
        event.name,
        event.email,
        event.password,
      );

      print('Register response: $response'); // Debug log

      if (response!.containsKey('user') && response['user'] != null) {
        try {
          final user = User.fromJson(response['user']);
          emit(AuthAuthenticated(user));
        } catch (e) {
          print('Error creating user from response: $e');
          emit(AuthError(
              'Registration successful but failed to load user data. Please try logging in.'));
        }
      } else {
        emit(AuthError('Invalid response format from server'));
      }
    } catch (e) {
      print('Registration error: $e'); // Debug log
      emit(AuthError(e.toString().replaceAll('Exception:', '')));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null && userData['user'] != null) {
        final user = User.fromJson(userData['user']);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      print('Check auth error: $e');
      emit(AuthInitial());
    }
  }
}
