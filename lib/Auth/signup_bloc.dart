import 'package:bloc/bloc.dart';
import '../Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
  }

  Future<void> addUser(
    Map<String, dynamic> body,
  ) async {
    // check if the password is the same as the confirmed password
    if (body['password'] != body['confirmedPassword']) {
      throw Exception('The passwords don\'t match.');
    }

    const String defaultPhotoUrl = 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';
    try {
      await AuthService.instance.signup(
        name    : body['name']!,
        email   : body['email']!,
        password: body['password']!,
        photoUrl: defaultPhotoUrl,
      );
    }
    catch (e) {
      String new_error = e.toString().split(',')[0].split('message:')[1].trim();
      throw new_error.replaceFirst(new_error[0], new_error[0].toUpperCase());
    }
  }

  Future<void> _onSignUpButtonPressed( SignUpButtonPressed event, Emitter<SignUpState> emit) async {
      emit(SignUpLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        List<Object> list = event.props;
        await addUser({
          'name'             : list[1].toString(),
          'email'            : list[2].toString(),
          'password'         : list[3].toString(),
          'confirmedPassword': list[4].toString(),
        });
        emit(SignUpSuccess());
        Navigator.pop(list[0] as BuildContext);
      }
      catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
  }
}