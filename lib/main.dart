import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/authentication/auth_controller.dart';
import 'package:information_dam/features/authentication/auth_repository.dart';
import 'package:information_dam/ui/auth_screen.dart';
import 'package:information_dam/ui/create_article_screen.dart';
import 'package:information_dam/ui/home_screen.dart';
import 'package:information_dam/utility/error_loader.dart';
import 'package:information_dam/utility/firebase_tools/firebase_options.dart';

final kTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF006633)));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  void _getData(User data) async {
    final person = await ref.read(authRepositoryProvider).getPersonData(data.uid).first;
    ref.read(personProvider.notifier).update((state) => person);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Information Dam",
      theme: kTheme,
      home: ref
          .watch(authStateChangeProvider)
          .when(
            data: (data) {
              if (data != null) {
                _getData(data);
                return const HomeScreen();
              }

              return const AuthScreen();
            },
            error: (error, stackTrace) => ErrorPage(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
