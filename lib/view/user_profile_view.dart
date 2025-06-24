import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/view/signup_view.dart';
import 'package:syllabus_tracker/viewModel/user_profile_view_model.dart';
import 'package:syllabus_tracker/widgets/change_username_popup.dart';
import 'package:syllabus_tracker/widgets/top_app_bar.dart';
import 'package:syllabus_tracker/widgets/bottom_bar.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(pageName: "Profile"),
      body: Consumer<UserProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.username == "") {
            viewModel.loadUsername();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hello, ${viewModel.username}!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),

                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 80,
                  child: InkWell(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => ChangeUsernamePopup(
                          controller: _usernameController,
                        ),
                      );

                      if (result != null && result.isNotEmpty) {
                        final response = await viewModel.verifyUsername(result);

                        if (response) {
                          await viewModel.changeUsername(result);
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Card(
                      color: Color(0xffb00000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(6),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Change Username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 80,
                  child: InkWell(
                    onTap: () async {
                      await viewModel.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupView()),
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Card(
                      color: Color(0xffb00000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(6),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sign Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(pageName: "profile"),
    );
  }
}
