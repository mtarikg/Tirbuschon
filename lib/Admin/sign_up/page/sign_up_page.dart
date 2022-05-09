
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tirbuschon_feng497/Admin/sign_up/bloc/sign_up_bloc.dart';
import 'package:tirbuschon_feng497/Admin/sign_up/widget/sign_up_content.dart';

class AdminSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<SignUpBloc> _buildBody(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (BuildContext context) => SignUpBloc(),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listenWhen: (_, currState) => currState is NextTabBarPageState || currState is NextSignInPageState || currState is ErrorState,
        listener: (context, state) {
           if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        buildWhen: (_, currState) => currState is SignupInitial,
        builder: (context, state) {
          return SignUpContent();
        },
      ),
    );
  }
}
