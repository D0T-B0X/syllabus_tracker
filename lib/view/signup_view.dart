import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/view/login_view.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupState();
}

class _SignupState extends State<SignupView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final signupView = context.watch<AuthViewModel>();
    // signupView.resetSuccess();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (signupView.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(signupView.errorMessage!)));
        signupView.clearError();
      }
      else if (signupView.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("SignUp Successful")));
        Navigator.pushNamed(context, '/subjects');
        signupView.resetSuccess();
      }
    });
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Sign Up",
              style: TextStyle(color: Colors.red, fontSize: 50),
            ),
            centerTitle: true,
            toolbarHeight: 140,
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
                          controller: nameController,
                          style: TextStyle(fontSize: 30),
                          onChanged: (value) {
                            signupView.verifyEmail(value);
                          },
                          decoration: InputDecoration(
                            labelText: "Name",
                            // errorText: signupView.email.error,
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
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(fontSize: 30),
                            onChanged: (value) {
                              signupView.verifyEmail(value);
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              errorText: signupView.email.error,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(fontSize: 30),
                            onChanged: (value) {
                              signupView.verifyPassword(value);
                            },
                            decoration: InputDecoration(
                              labelText: "Set a Password",
                              errorText: signupView.password.error,
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
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(fontSize: 30),
                          onChanged: (value) {
                            signupView.verifyPassword(value);
                          },
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            errorText: signupView.password.error,
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
                          padding: const EdgeInsets.only(top: 60, bottom: 40),
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
                              final name = nameController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final confirmPassword = confirmPasswordController.text.trim();
                              context.read<AuthViewModel>().signUpButton(
                                name, email,password, confirmPassword,
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
        if (signupView.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
