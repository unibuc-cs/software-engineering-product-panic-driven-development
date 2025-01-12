import '../Menu.dart';
import 'package:bloc/bloc.dart';
import '../Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> checkUser(
    Map<String, dynamic> body,
  ) async {
    try {
      await AuthService.instance.login(
        email: body['email']!,
        password: body['password']!,
      );
    }
    catch (e) {
      String new_error = e.toString().split(',')[0].split('message:')[1].trim();
      throw new_error.replaceFirst(new_error[0], new_error[0].toUpperCase());
    }
  }

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      List<Object> list = event.props;
      await checkUser({
        'email'    : list[1].toString(),
        'password' : list[2].toString(),
      });
      emit(LoginSuccess());
      Navigator.pop(list[0] as BuildContext);
      Navigator.pop(list[0] as BuildContext);
      Navigator.of(list[0] as BuildContext)
          .push(MaterialPageRoute(builder: (context) => const Menu()));
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
