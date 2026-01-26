import 'package:flutter/material.dart';
//TODO exctract constants
const String kInfo =
    "This project is about dealing with information in a new way. The idea is to slow things down. News always moves so fast; it's different every week, and there's never enough time to stop and figure out what's important and what's garbage. In addition, we have restricted the use of this forum to a specific physical location somewhere in public. All contributions come from those around you, or at least, within the vicinity. We hope that you, potential user, see fit to personally invest in the community around this idea. The idea is we aren't trying to work thru this information by ourselves, we are doing it together! And we are taking the time we need to really understand what's going on. ";

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('info')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: const Text(kInfo)),
    );
  }
}
