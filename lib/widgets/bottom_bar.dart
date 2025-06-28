import 'package:flutter/material.dart';
import 'package:syllabus_tracker/view/leaderboard_view.dart';
import 'package:syllabus_tracker/view/subject_list_view.dart';
import 'package:syllabus_tracker/view/user_profile_view.dart';

/// Custom bottom navigation bar widget providing navigation between main app sections.
/// Highlights the current page and provides scroll-to-top functionality for applicable pages.
class BottomBar extends StatelessWidget {
  /// The name of the current page for highlighting the active button
  final String pageName;

  /// Optional scroll controller for scroll-to-top functionality
  final ScrollController? scrollController;

  /// Creates a new bottom navigation bar
  const BottomBar({super.key, required this.pageName, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          // Home/Subjects button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // Highlight if current page is subjects
                color: pageName == "subjects"
                    ? Color(0x2f000000)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: () {
                  if (pageName == "subjects") {
                    // Scroll to top if already on subjects page
                    scrollController!.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  } else {
                    // Navigate to subjects page and clear navigation stack
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

          // Leaderboard button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // Highlight if current page is leaderboard
                color: pageName == "leaderboard"
                    ? Color(0x2f000000)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: () {
                  if (pageName == "leaderboard") {
                    // Scroll to top if already on leaderboard page
                    scrollController!.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  } else {
                    // Navigate to leaderboard page and clear navigation stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LeaderboardView(),
                      ),
                      (route) => false,
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
                // Highlight if current page is profile
                color: pageName == "profile"
                    ? Color(0x2f000000)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: () {
                  if (pageName != "profile") {
                    // Navigate to profile page and clear navigation stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => UserProfileView()),
                      (route) => false,
                    );
                  }
                  // No scroll-to-top for profile page as it's a single screen
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
