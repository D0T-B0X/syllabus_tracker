import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/topics_list_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopicsListView extends StatefulWidget {
  final String? courseCode;
  const TopicsListView({super.key, this.courseCode});

  @override
  State<TopicsListView> createState() => _TopicsListViewState();
}

class _TopicsListViewState extends State<TopicsListView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TopicsViewModel>(context);

    if (viewModel.selectedCode != widget.courseCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.setSelectedCode(widget.courseCode!);
      });
    }

    final userID = Supabase.instance.client.auth.currentUser?.id;
    final course = viewModel.getCourse(widget.courseCode!);
    final selections = viewModel.getList(widget.courseCode!);
    final topicNames = selections.keys.toList();
    final progress = viewModel.progress(widget.courseCode!);
    String percentProgress = (progress * 100).toStringAsFixed(0);

    MainAxisAlignment.center;
    MainAxisSize.max;
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(course?.name ?? '', style: TextStyle(fontSize: 25)),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: Color(0xFFDB1304),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFCCCC),
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      // padding: EdgeInsets.only(left: 15, top: 30, bottom: 30, right: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 30,
                          bottom: 30,
                          right: 15,
                        ),
                        child: Material(
                          elevation: 7,
                          borderRadius: BorderRadius.circular(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(6),
                              backgroundColor: Color(0xFFDB1304),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    // Positioned(
                    //   right: 5,
                    //   child:
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        "$percentProgress%",
                        style: TextStyle(fontSize: 20),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text("Topics", style: TextStyle(fontSize: 25)),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                            top: 10,
                          ),
                          children: topicNames.map((topic) {
                            final ifChecked = selections[topic] ?? false;
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFCCCC),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: CheckboxListTile(
                                  title: Text(
                                    topic,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  activeColor: Colors.blueAccent,
                                  value: ifChecked,
                                  onChanged: (val) {
                                    if (userID != null) {
                                      viewModel.toggleTopic(
                                        widget.courseCode!,
                                        topic,
                                        val!,
                                        userID,
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    // )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
