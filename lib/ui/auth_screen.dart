import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/features/authentication/auth_controller.dart';
import 'package:information_dam/utility/text_validation.dart';

import 'custom_widgets.dart';
import '../utility/location_service.dart';

const String kLocationDisclaimer = "The use of this platform is restricted to those physically on campus, so we need your location please.";

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLocated = false;
  bool _wantsCommunication = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _preferenceController = TextEditingController();

  final _logInEmailControl = TextEditingController();
  final _logInPassControl = TextEditingController();
  bool _obscurePassword = true;

  Widget get _obscurePasswordSwitch => ElevatedButton(
    onPressed: () {
      setState(() {
        _obscurePassword = !_obscurePassword;
      });
    },
    child: const Text('show password'),
  );

  void _createAccount() {
    ref
        .read(authControllerProvider.notifier)
        .createAccount(
          context,
          _emailController.text,
          _passwordController.text,
          _wantsCommunication,
          preference: validTextValueReturner(_preferenceController),
        );
  }

  void _logIn() {
    ref.read(authControllerProvider.notifier).logIn(context, _logInEmailControl.text, _logInPassControl.text);
  }

  void _useAnonymously() {
    ref.read(authControllerProvider.notifier).useWithoutAccount(context);
  }

  void _showLocatedLogIn() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          constraints: BoxConstraints(maxHeight: 250),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                customTextField(controller: _logInEmailControl, hintText: "email"),
                customTextField(controller: _logInPassControl, hintText: 'password', obscureText: _obscurePassword),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value) {
        _logIn();
      }
    });
  }

  void _showNoLocoLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          constraints: BoxConstraints(maxHeight: 300),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 80),
                    Expanded(child: const Text('read only access is available for those who already have an account')),
                    const SizedBox(width: 40),
                  ],
                ),
                customTextField(controller: _logInEmailControl, hintText: "email"),

                customTextField(controller: _logInPassControl, hintText: 'password', obscureText: _obscurePassword),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('cancel'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          //TODO implement NOLOCATION functions
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value) {
        _logIn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocated) {
      return _authScreen;
    }
    return _opener;
  }

  Widget get _opener {
    return Scaffold(
      appBar: customAppBar("Welcome", hasInfoButton: true, context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(kLocationDisclaimer),
              ElevatedButton(
                onPressed: () {
                  isProperlyLocated().then((value) {
                    if (value) {
                      setState(() {
                        _isLocated = true;
                      });
                    } else {
                      _showNoLocoLogin();
                    }
                  });
                },
                child: const Text('ok'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////MAIN SCREEN////////////////////////////////////////////////////////
  Widget get _authScreen {
    return Scaffold(
      appBar: customAppBar(
        "So Glad You're Here!",
        hasInfoButton: true,
        context: context,
        actions: [Center(child: GestureDetector(onTap: _showLocatedLogIn, child: const Text('Sign In')))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Create Your Account Here"),
              Column(
                children: [
                  const Text('email'),
                  customTextField(controller: _emailController, outlineField: true),
                ],
              ),
              Column(
                children: [
                  const Text('password'),
                  customTextField(controller: _passwordController, outlineField: true, obscureText: _obscurePassword),
                  _obscurePasswordSwitch,
                ],
              ),

              CheckboxListTile(
                title: const Text("select if you would like to recieve communication from the project team."),
                value: _wantsCommunication,
                onChanged: (value) {
                  setState(() {
                    _wantsCommunication = value!;
                  });
                },
              ),
              if (_wantsCommunication)
                Column(
                  children: [
                    //TODO redo sentence "let us know what you think"
                    Text("Please let us know what kinds of emails are good or bad for you, if you can think of any."),
                    TextField(
                      controller: _preferenceController,
                      maxLines: 3,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: _createAccount,
                child: const Text('create account', style: TextStyle(fontSize: 20)),
              ),
              TextButton(onPressed: _useAnonymously, child: const Text("(optional) use without creating an account")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _preferenceController.dispose();
    _logInEmailControl.dispose();
    _logInPassControl.dispose();
  }
}
