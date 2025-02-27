import 'package:ai_journal_app/common/widget/app_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../home_screen.dart';
import '../controllers/login_controller.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<ShadFormState>();

  void _onLoginTap() {
    if (_formKey.currentState!.validate()) {
      LoginController.to.login(
        _emailController.text,
        _passwordController.text,
        onSuccess: _onSuccess,
      );
    }
  }

  void _onSuccess() {
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
  }

  void _onCreateAccountTap() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupView()));
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
            child: GetBuilder<LoginController>(
              builder: (controller) {
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
                      "Login to continue",
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
                          text: "Login",
                          onPressed: _onLoginTap,
                          isLoading: controller.isLoading,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Register",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                recognizer: TapGestureRecognizer()..onTap = _onCreateAccountTap,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
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
