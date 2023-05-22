import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'providers/project_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with AutomaticKeepAliveClientMixin<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((user) {
      if (user == null) {
        // Delay navigation until after the widget tree is built.
        Future.delayed(Duration.zero, () {
          // Se l'utente non è autenticato, reindirizza alla schermata di login
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorSchemeSeed: const Color.fromRGBO(5, 107, 241, 1),
          disabledColor: Colors.red,
          useMaterial3: true,
        ),
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}
