import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/view/login_view.dart';
import 'package:syllabus_tracker/view/signup_view.dart';
import 'package:syllabus_tracker/view/subject_list_view.dart';
import 'package:syllabus_tracker/view/splash_screen_view.dart';
import 'package:syllabus_tracker/view/user_profile_view.dart';
import 'package:syllabus_tracker/view/leaderboard_view.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';
import 'package:syllabus_tracker/viewModel/splash_screen_view_model.dart';
import 'package:syllabus_tracker/viewModel/subject_list_view_model.dart';
import 'package:syllabus_tracker/viewModel/user_profile_view_model.dart';
import 'package:syllabus_tracker/viewModel/leaderboard_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env['ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => SubjectListViewModel()),
        ChangeNotifierProvider(create: (_) => UserProfileViewModel()),
        ChangeNotifierProvider(create: (_) => LeaderboardViewModel()),
      ],
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenView(),
        '/login': (context) => LoginView(),
        '/signup': (context) => const SignupView(),
        '/subjects': (context) => const SubjectListView(),
        '/profile': (context) => UserProfileView(),
        '/leaderboard': (context) => LeaderboardView(),
      },
    );
  }
}
