import 'package:flutter/material.dart';
import 'package:syllabus_tracker/view/subject_list_view.dart';
import 'package:syllabus_tracker/view/user_profile_view.dart';

class BottomBar extends StatelessWidget {
  final String pageName;
  final ScrollController? scrollController;

  const BottomBar({super.key, required this.pageName, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          // Home button (scrolls to top)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: pageName == "subjects"
                    ? Color(0x2f000000)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: () {
                  if (pageName == "subjects") {
                    // Scroll to the top of the subject list when pressed
                    scrollController!.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubjectListView(),
                      ),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(Icons.home_filled),
              ),
            ),
          ),

          // Leader board button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: pageName == "leaderboard"
                    ? Color(0x2f000000)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: () {
                  if (pageName == "leaderboard") {
                    // Scroll to the top of the subject list when pressed
                    scrollController!.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  }
                },
                icon: Icon(Icons.leaderboard),
              ),
            ),
          ),

          // User Profile button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: pageName == "profile"
                    ? Color(0x2f000000)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: () {
                  if (pageName != "profile") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => UserProfileView()),
                      (route) => false,
                    );
                  }
                },
                icon: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
