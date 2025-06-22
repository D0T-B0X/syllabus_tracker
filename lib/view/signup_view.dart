import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/view/login_view.dart';
import 'package:syllabus_tracker/viewModel/signUp_view_model.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final email_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  final confirmPassword_Controller = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<SignUpViewModel>();
      if (vm.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
        vm.clearError();
      }
      if (vm.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("SignUp Successful")));
        Navigator.pushNamed(context, '/subjects');
        vm.resetSuccess();
      }
    });
    final viewModel = context.watch<AuthViewModel>();
    final signUp = context.watch<SignUpViewModel>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Sign Up",
              style: TextStyle(color: Colors.red, fontSize: 50),
            ),
            centerTitle: true,
            toolbarHeight: 200,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email_Controller,
                          style: TextStyle(fontSize: 30),
                          onChanged: (value) {
                            viewModel.verifyEmail(value);
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            errorText: viewModel.email.error,
                            labelStyle: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: TextFormField(
                            controller: password_Controller,
                            obscureText: _obscurePassword,
                            style: TextStyle(fontSize: 30),
                            onChanged: (value) {
                              viewModel.verifyPassword(value);
                            },
                            decoration: InputDecoration(
                              labelText: "Set a Password",
                              errorText: viewModel.password.error,
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  transitionBuilder: (child, animation) =>
                                      RotationTransition(
                                        turns: animation,
                                        child: child,
                                      ),
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    key: ValueKey<bool>(_obscurePassword),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: confirmPassword_Controller,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(fontSize: 30),
                          onChanged: (value) {
                            viewModel.verifyPassword(value);
                          },
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            errorText: viewModel.password.error,
                            labelStyle: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) =>
                                    RotationTransition(
                                      turns: animation,
                                      child: child,
                                    ),
                                child: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  key: ValueKey<bool>(_obscureConfirmPassword),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80, bottom: 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 25),
                            ),
                            onPressed: () async {
                              final email = email_Controller.text.trim();
                              final password = password_Controller.text.trim();
                              final confirmPassword = confirmPassword_Controller.text.trim();
                              context.read<SignUpViewModel>().SignUpButton(
                                email, password, confirmPassword,
                              );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginView()),
                            );
                          },
                          child: Text(
                            "Already have an Account? Login",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (signUp.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  @override
  void dispose() {
    email_Controller.dispose();
    password_Controller.dispose();
    confirmPassword_Controller.dispose();
    super.dispose();
  }
}
