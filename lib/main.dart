import 'package:bluebot/components/login_screen.dart';
import 'package:bluebot/components/main_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'data_store/global_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  runApp(
    ChangeNotifierProvider(create: (_) => UserStore(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlueBot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? _isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final box = Hive.box('userBox');
    final session = box.get('user_session');
    if (!Hive.isBoxOpen('userBox')) {
      await Hive.openBox('userBox');
    }
    final userName = session?['user_name'];

    if (userName == null) {
      setState(() {
        _isUserLoggedIn = false;
      });
      return;
    }

    try {
      final uri = Uri.parse(
        'http://192.168.248.73:3000/isUserLoggedIn?user_name=$userName',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final isLoggedIn = response.body.trim() == "true"; // or parse json
        if (isLoggedIn) {
          context.read<UserStore>().setUsername(userName);
        }
        setState(() {
          _isUserLoggedIn = isLoggedIn;
        });
      } else {
        setState(() {
          _isUserLoggedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUserLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isUserLoggedIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isUserLoggedIn! ? const MainAppScreen() : const LoginScreen();
  }
}
