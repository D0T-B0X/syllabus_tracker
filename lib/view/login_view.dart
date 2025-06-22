import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/view/signup_view.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';

//╔══════════════════════════════════════════════════════════════════════════╗
//║ LOGIN VIEW                                                               ║
//║                                                                          ║
//║ Provides user interface for authentication including email/password      ║
//║ input fields and login submission handling.                              ║
//╚══════════════════════════════════════════════════════════════════════════╝
class LoginView extends StatelessWidget {
  //┌─────────────────────────────────────────────┐
  //│ CONTROLLERS                                 │
  //└─────────────────────────────────────────────┘

  /// Controls the email input field text
  final TextEditingController _emailController = TextEditingController();

  /// Controls the password input field text
  final TextEditingController _passwordController = TextEditingController();

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
                      style: TextStyle(color: Colors.red, fontSize: 40),
                    ),
                    SizedBox(height: 24),

                    // Email input field
                    TextField(
                      controller: _emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        errorText: viewModel.email.error,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Password input field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        errorText: viewModel.password.error,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Login button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
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
                            String result;

                            // 4. Handle authentication result
                            if (success) {
                              result = "Login Successful";
                              Navigator.pushNamed(context, '/subjects');
                            } else {
                              result =
                                  "Login failed. Please Check your credentials";
                            }

                            // 5. Show feedback to user
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(result)));
                          } catch (e) {
                            // Handle unexpected errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text('Submit'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: TextButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const signUp()),
                        );
                      },
                          child: const Text("Don't have an account? SignUp",
                          style: TextStyle(
                            fontSize: 20,
                          ),)),
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
