import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:information_dam/navigation.dart';
import 'package:information_dam/ui/custom_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        "this is home screen",
        hasInfoButton: true,
        context: context,
        actions: [TextButton(onPressed: () => GoTo.createPostScreen(context), child: const Text("create"))],
      ),
      body: Placeholder(),
    );
  }
}
