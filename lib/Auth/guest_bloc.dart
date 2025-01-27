import 'dart:math';
import 'package:bloc/bloc.dart';
import '../Menu.dart';
import '../UserSystem.dart';
import '../Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

part 'guest_event.dart';
part 'guest_state.dart';

String generateRandomString() {
    var r = Random();
    int len = max(15,r.nextInt(20));
    const chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length-1)]).join();
  }

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  GuestBloc() : super(GuestInitial()) {
    on<GuestButtonPressed>(_onGuestButtonPressed);
  }

  Future<void> addUser() async {
    final name = 'guest_${generateRandomString()}';
    final email = '$name@gmail.com';
    final password = generateRandomString();

    try {
      await AuthService.instance.signup(
        name    : name,
        email   : email,
        password: password,
        isGuest : true,
      );
      await AuthService.instance.login(
        email   : email,
        password: password,
      );
      await UserSystem.instance.login();
    }
    catch (e) {
      String new_error = e.toString().split(',')[0].split('message:')[1].trim();
      throw new_error.replaceFirst(new_error[0], new_error[0].toUpperCase());
    }
  }

  Future<void> _onGuestButtonPressed( GuestButtonPressed event, Emitter<GuestState> emit) async {
      emit(GuestLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));
        List<Object> list = event.props;
        await addUser();
        emit(GuestSuccess());
        Navigator.pop(list[0] as BuildContext);
        Navigator.pop(list[0] as BuildContext);
        Navigator
          .of(list[0] as BuildContext)
          .push(
            MaterialPageRoute(builder: (context) => const Menu())
          );
      }
      catch (error) {
        emit(GuestFailure(error: error.toString()));
      }
  }
}
