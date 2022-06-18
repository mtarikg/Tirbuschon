import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tirbuschon_feng497/Admin/add_new_restaurant/bloc/rest_add_bloc.dart';
import 'package:tirbuschon_feng497/Admin/add_new_restaurant/common_widgets/admin_button.dart';
import 'package:tirbuschon_feng497/Admin/add_new_restaurant/common_widgets/admin_loading.dart';
import 'package:tirbuschon_feng497/Admin/add_new_restaurant/common_widgets/admin_text_field.dart';
import 'package:tirbuschon_feng497/Admin/validation_service.dart';
import 'package:tirbuschon_feng497/Auth/loginPage.dart';

class SignUpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            _createMainData(context),
            BlocBuilder<SignUpBloc, SignUpState>(
              buildWhen: (_, currState) =>
                  currState is LoadingState ||
                  currState is NextTabBarPageState ||
                  currState is ErrorState,
              builder: (context, state) {
                if (state is LoadingState) {
                  return _createLoading();
                } else if (state is NextTabBarPageState ||
                    state is ErrorState) {
                  return SizedBox();
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createMainData(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _createTitle(),
            // const SizedBox(height: 50),
            _createForm(context),
            const SizedBox(height: 40),
            _createSignUpButton(context),
            // Spacer(),
            const SizedBox(height: 40),
            _createSignOutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _createLoading() {
    return AdminLoading();
  }

  Widget _createTitle() {
    return Text(
      'New Venue',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (_, currState) => currState is ShowErrorState,
      builder: (context, state) {
        return Column(
          children: [
            AdminTextField(
              title: 'Venue Name',
              placeholder: 'Name',
              controller: bloc.venueNameController,
              textInputAction: TextInputAction.next,
              errorText: 'Please check the name again',
              isError: state is ShowErrorState
                  ? !ValidationService.username(bloc.venueNameController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            AdminTextField(
              title: 'Venue Email',
              placeholder: 'Email',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: bloc.emailController,
              errorText: 'Please check the email again',
              isError: state is ShowErrorState
                  ? !ValidationService.email(bloc.emailController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            AdminTextField(
              title: 'Venue Temporary Password',
              placeholder: 'Password',
              obscureText: true,
              isError: state is ShowErrorState
                  ? !ValidationService.password(bloc.passwordController.text)
                  : false,
              textInputAction: TextInputAction.next,
              controller: bloc.passwordController,
              errorText: 'Please check the password again',
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            AdminTextField(
              title: 'Venue Address',
              placeholder: 'Address',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              controller: bloc.venueAddressController,
              errorText: 'Please check the address again',
              //isError: state is ShowErrorState ? !ValidationService.email(bloc.userWeightController.text) : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            AdminTextField(
              title: 'Venue Phone',
              placeholder: 'Phone',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: bloc.venuePhoneController,
              errorText: 'Please check the phone again',
              //isError: state is ShowErrorState ? !ValidationService.email(bloc.userWeightController.text) : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            AdminTextField(
              title: 'Venue Capacity',
              placeholder: 'Capacity',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: bloc.venueCapacityController,
              errorText: 'Please check the capacity again',
              //isError: state is ShowErrorState ? !ValidationService.email(bloc.userHeightController.text) : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            AdminTextField(
              title: 'Venue Reservation Capacity',
              placeholder: 'Reservation Capacity',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: bloc.venueReservCapacityController,
              errorText: 'Please check the reservation capacity again',
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createSignUpButton(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (_, currState) =>
            currState is SignUpButtonEnableChangedState,
        builder: (context, state) {
          return AdminButton(
            title: 'Register New Venue',
            isEnabled: state is SignUpButtonEnableChangedState
                ? state.isEnabled
                : false,
            onTap: () {
              FocusScope.of(context).unfocus();
              bloc.add(SignUpTappedEvent());
            },
          );
        },
      ),
    );
  }

  Widget _createSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AdminButton(
        title: 'Sign Out',
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
      ),
    );
  }
}
