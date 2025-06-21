import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/subject_list_view_model.dart';

class SubjectListView extends StatelessWidget {
  const SubjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syllabus Tracker'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: 'Leaderboard',
            onPressed: () {
              // TODO => implement leaderboard page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leaderboard tapped!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<SubjectListViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.subjectsLoaded && !viewModel.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadSubjectData();
            });
          }

          if (viewModel.isLoading || !viewModel.subjectsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final subjects = viewModel.subjectNames;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:
                      () {}, // TODO => implement paths when subject cards are tapped
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          subjects[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
