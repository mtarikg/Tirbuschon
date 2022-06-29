import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tirbuschon_feng497/Admin/rest_add_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tirbuschon_feng497/Admin/validation_service.dart';

part 'rest_add_event.dart';
part 'rest_add_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignUpState> {
  SignUpBloc() : super(SignupInitial()) {
    on<OnTextChangedEvent>(_OnTextChangedEvent);
    on<SignUpTappedEvent>(_SignUpTappedEvent);
    on<SignInTappedEvent>(_SignInTappedEvent);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final venueNameController = TextEditingController();
  final venueAddressController = TextEditingController();
  final venuePhoneController = TextEditingController();
  final venueCapacityController = TextEditingController();
  final venueReservCapacityController = TextEditingController();
  final venueTypeDrop = TextEditingController();
  //final venueTypeDrop = DragDownDetails();

  bool isButtonEnabled = false;

  // ignore: non_constant_identifier_names
  void _OnTextChangedEvent(
      OnTextChangedEvent event, Emitter<SignUpState> emit) {
    if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
      isButtonEnabled = checkIfSignUpButtonEnabled();
      emit(SignUpButtonEnableChangedState(isEnabled: isButtonEnabled));
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _SignUpTappedEvent(
      SignUpTappedEvent event, Emitter<SignUpState> emit) async {
    if (checkValidatorsOfTextField()) {
      try {
        emit(LoadingState());
        await AdminAuthService.signUp(
            emailController.text,
            passwordController.text,
            venueNameController.text,
            venueAddressController.text,
            venueCapacityController.text,
            venueReservCapacityController.text,
            venuePhoneController.text,
            venueTypeDrop.text);

        emailController.text = '';
        passwordController.text = '';
        venueNameController.text = '';
        venueAddressController.text = '';
        venueCapacityController.text = '';
        venueReservCapacityController.text = '';
        venuePhoneController.text = '';
        venueTypeDrop.text = '';

        emit(NextTabBarPageState());
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    } else {
      emit(ShowErrorState());
    }
  }

// ignore: non_constant_identifier_names
  void _SignInTappedEvent(SignInTappedEvent event, Emitter<SignUpState> emit) {
    emit(NextSignInPageState());
  }

  bool checkIfSignUpButtonEnabled() {
    return venueNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        venueAddressController.text.isNotEmpty &&
        venuePhoneController.text.isNotEmpty &&
        venueReservCapacityController.text.isNotEmpty &&
        venueCapacityController.text.isNotEmpty &&
        venueTypeDrop.text.isNotEmpty;
  }

  bool checkValidatorsOfTextField() {
    return ValidationService.username(venueNameController.text) &&
        ValidationService.email(emailController.text) &&
        ValidationService.password(passwordController.text);
  }
}
