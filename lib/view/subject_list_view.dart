import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/subject_list_view_model.dart';

/// Displays the list of subjects in a grid with a custom bottom navigation bar.
class SubjectListView extends StatelessWidget {
  const SubjectListView({super.key});

  // Static ScrollController to control scrolling of the GridView.
  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Custom bottom navigation bar with Home and Leaderboard icons.
      bottomNavigationBar: BottomAppBar(
        height: 70.0,
        color: Colors.white,
        child: Row(
          children: [
            // Home button (scrolls to top)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x2f000000),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  onPressed: () {
                    // Scroll to the top of the subject list when pressed
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  },
                  icon: Icon(Icons.home_filled),
                ),
              ),
            ),
            // Leaderboard button (currently does nothing)
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.leaderboard),
              ),
            ),
          ],
        ),
      ),

      // App bar with centered title and no back button
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Syllabus Tracker',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),

      // Main body: List of subjects
      body: Consumer<SubjectListViewModel>(
        builder: (context, viewModel, child) {
          // Load data if not already loaded
          if (!viewModel.subjectsLoaded && !viewModel.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadSubjectData();
            });
          }

          // Show loading indicator while loading
          if (viewModel.isLoading || !viewModel.subjectsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get the list of subject names
          final subjects = viewModel.subjectNames;

          // Display subjects in a single-column grid
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 1.0,
            ),
            child: GridView.builder(
              controller: _scrollController, // Attach controller for scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                childAspectRatio: 2.61,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    // TODO: implement navigation when subject card is tapped
                  },
                  child: Card(
                    color: const Color(0xffb00000),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: SizedBox(
                          width:
                              MediaQuery.of(context).size.width *
                              0.5, // Limit text width
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subject name (primary text)
                              Text(
                                subjects[index],
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Subject code (subtext)
                              Text(
                                "Subject Code: ${viewModel.subjectNameCodeMap[subjects[index]]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[350],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
