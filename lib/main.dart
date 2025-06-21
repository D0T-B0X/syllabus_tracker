// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:syllabus_tracker/viewModel/auth_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:syllabus_tracker/view/login_view.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//
//   await Supabase.initialize(
//     url: "https://pkuypepnumpkbldwwfue.supabase.co",
//     anonKey: dotenv.env['ANON_KEY']!,
//   );
//
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => AuthViewModel(),
//       child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: LoginView()),
//     ),
//   );
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syllabus_tracker/view/login_view.dart';
import 'package:syllabus_tracker/view/signup_view.dart';
import 'package:syllabus_tracker/view/subject_list_view.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';
import 'package:syllabus_tracker/viewModel/signUp_view_model.dart';
import 'package:syllabus_tracker/viewModel/subject_list_view_model.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env['ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => SubjectListViewModel()),
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/signUp': (context) => const signUp(),
        '/subjects': (context) => const SubjectListView(),
      },
    );
  }
}
