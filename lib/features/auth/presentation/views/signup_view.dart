import 'package:ai_journal_app/common/widget/app_buttons.dart';
import 'package:ai_journal_app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:ai_journal_app/features/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<ShadFormState>();

  void _registerTap() {
    if (_formKey.currentState!.validate()) {
      SignUpController.to.signUp(_emailController.text, _passwordController.text, onSuccess: _registrationSuccessful);
    }
  }

  void _registrationSuccessful() {
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
  }

  void _loginTap() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ShadForm(
            key: _formKey,
            child: GetBuilder<SignUpController>(builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to \nAI Journal",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Create an account to continue",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  // Spacer(),
                  ShadInputFormField(
                    id: 'email',
                    controller: _emailController,
                    label: const Text('Email'),
                    placeholder: const Text('Enter your email'),
                    validator: (v) {
                      if (!v.isEmail) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  ShadInputFormField(
                    id: 'password',
                    controller: _passwordController,
                    label: const Text('Password'),
                    placeholder: const Text('Enter your password'),
                  ),
                  SizedBox(height: 40),

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppPrimaryButton(
                        text: "Register",
                        onPressed: _registerTap,
                        isLoading: controller.isLoading,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "Login",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()..onTap = _loginTap,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
