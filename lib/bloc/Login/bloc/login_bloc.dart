import 'dart:async';
import 'package:bloc/bloc.dart';
// ignore: unused_import
import '../../../model/user.dart';
import '../../../services/authentication_service.dart';
import './login_event.dart';
import './login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService authService;

  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<LoginRequested>(_handleLogin);
  }

  Future<void> _handleLogin(LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final bool isAuthenticated = await authService.login(event.username,event.password);
      if (isAuthenticated) {
        emit(LoginSuccess(username: event.username));
      } else {
        emit(LoginFailure(error: 'Authentication failed'));
      }
    } catch (error) {
      emit(LoginFailure(error: 'Xin Hãy Đăng Nhập Lại'));
    }
  }
}
