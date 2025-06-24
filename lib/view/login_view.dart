import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/view/signup_view.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';
import 'package:syllabus_tracker/view/subject_list_view.dart';

//╔══════════════════════════════════════════════════════════════════════════╗
//║ LOGIN VIEW                                                             ║
//║ Provides user interface for authentication including email/password     ║
//║ input fields and login submission handling.                            ║
//╚══════════════════════════════════════════════════════════════════════════╝
class LoginView extends StatelessWidget {
  //┌─────────────────────────────────────────────┐
  //│ CONTROLLERS                                 │
  //└─────────────────────────────────────────────┘

  /// Controls the email input field text
  final TextEditingController _emailController = TextEditingController();

  /// Controls the password input field text
  final TextEditingController _passwordController = TextEditingController();

  /// State Manager for password obscure parameter
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  /// Default constructor
  LoginView({super.key});

  //┌─────────────────────────────────────────────┐
  //│ BUILD METHOD                                │
  //└─────────────────────────────────────────────┘
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Card(
          elevation: 0,
          // Card contains the entire login form
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Consumer<AuthViewModel>(
              // Consumer rebuilds when AuthViewModel changes
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title section
                    Text(
                      'Login',
                      style: TextStyle(
                        color: const Color(0xffb00000),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Email input field
                    TextField(
                      controller: _emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        errorText: viewModel.email.error,
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Password input field with toggle visibility
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscure, _) {
                        return TextField(
                          controller: _passwordController,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            errorText: viewModel.password.error,
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            // Toggle password visibility
                            suffixIcon: IconButton(
                              onPressed: () {
                                _obscurePassword.value =
                                    !_obscurePassword.value;
                              },
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffb00000),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        onPressed: () async {
                          // 1. Extract input values
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          // 2. Validate credentials
                          viewModel.verifyEmail(email);
                          viewModel.verifyPassword(password);

                          // 3. Attempt login if validation passes
                          if (viewModel.email.error == null &&
                              viewModel.password.error == null) {
                            try {
                              // Authenticate with Supabase
                              final success = await viewModel.signIn();
                              String result = "";

                              // 4. Handle authentication result
                              if (success) {
                                String? displayName = viewModel.getUsername();
                                if (displayName == null) {
                                  result = "Welcome!";
                                } else {
                                  result = "Welcome, $displayName!";
                                }
                                // Navigate to SubjectListView and remove all previous routes
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SubjectListView(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                // 5. Show feedback to user
                                result =
                                    "Login failed. Please Check your credentials";
                              }
                              // Show result as a SnackBar
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            } catch (e) {
                              // Handle unexpected errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Sign up navigation button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignupView()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
}
