import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syllabus_tracker/viewModel/auth_view_model.dart';
import 'package:syllabus_tracker/view/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: "https://pkuypepnumpkbldwwfue.supabase.co",
    anonKey: dotenv.env['ANON_KEY']!,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: MaterialApp(home: LoginView()),
    ),
  );
}
