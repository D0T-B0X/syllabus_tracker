import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/leaderboard_view_model.dart';
import 'package:syllabus_tracker/widgets/bottom_bar.dart';
import 'package:syllabus_tracker/widgets/top_app_bar.dart';

/// Displays the leaderboard showing users ranked by topics completed.
/// Features special highlighting for top 3 positions with different colors.
class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  /// Static scroll controller for the leaderboard grid
  static final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeaderboardViewModel>(context, listen: false).loadData();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(pageName: "Leaderboard"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: Consumer<LeaderboardViewModel>(
          builder: (context, viewModel, child) {
            // Show loading indicator while data is being fetched
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show error message if data loading fails
            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Error: ${viewModel.error}",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.loadData(); // Retry loading data
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
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
                              userData['topics_completed']?.toString() ?? '0',
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
