import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Consumer<AuthViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(color: Colors.red, fontSize: 40),
                    ),
                    SizedBox(height: 24),
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        viewModel.verifyEmail(email);
                        viewModel.verifyPassword(password);

                        if (viewModel.email.error == null &&
                            viewModel.password.error == null) {
                          try {
                            final success = await viewModel.signIn();
                            String result;

                            if (success) {
                              result = "Login Successful";
                            } else {
                              result =
                                  "Login failed. Please Check your credentials";
                            }

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(result)));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text('Submit'),
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
