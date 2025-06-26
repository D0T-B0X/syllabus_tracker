import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/leaderboard_view_model.dart';
import 'package:syllabus_tracker/widgets/bottom_bar.dart';
import 'package:syllabus_tracker/widgets/top_app_bar.dart';

/// Displays the leaderboard showing users ranked by topics completed.
/// Features special highlighting for top 3 positions with different colors.
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  /// Static scroll controller for the leaderboard grid
  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(pageName: "Leaderboard"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: Consumer<LeaderboardViewModel>(
          builder: (context, viewModel, child) {
            // Load data if not already loaded and not currently loading
            if (viewModel.userDataMap.isEmpty && !viewModel.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                viewModel.loadData();
              });
            }

            // Show error message if data loading fails
            if (viewModel.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(viewModel.error!)));
              });
            }

            // Show loading indicator while data is being fetched
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
              child: GridView.builder(
                controller: _scrollController,
                itemCount: viewModel.userDataMap.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Single column layout
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 10,
                  childAspectRatio: 4, // Wide cards for ranking display
                ),
                itemBuilder: (context, index) {
                  // Convert map to list to maintain sorted order from database
                  final entries = viewModel.userDataMap.entries.toList();
                  final userData = entries[index].value;

                  // Set highlight colors for top 3 positions
                  Color? highlightColor;
                  if (index == 0) {
                    highlightColor = Color(
                      0xfff57a7a,
                    ); // First place - lightest red
                  } else if (index == 1) {
                    highlightColor = Color(
                      0xffde4747,
                    ); // Second place - medium red
                  } else if (index == 2) {
                    highlightColor = Color(
                      0xffdb1414,
                    ); // Third place - darker red
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Card(
                      elevation: 0,
                      color:
                          highlightColor ??
                          Color(0xffb00000), // Default app primary color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display rank and username
                            Text(
                              "${index + 1}  ${userData['username']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            // Display topics completed count
                            Text(
                              userData['topics_completed'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomBar(pageName: 'leaderboard'),
    );
  }
}
