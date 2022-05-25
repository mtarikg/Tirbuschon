part of 'rest_add_bloc.dart';

@immutable
abstract class SignupEvent {}

class OnTextChangedEvent extends SignupEvent {}

class SignUpTappedEvent extends SignupEvent {}

class SignInTappedEvent extends SignupEvent {}
