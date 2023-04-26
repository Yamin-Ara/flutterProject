import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyView extends StatefulWidget {
  const EmergencyView({super.key});

  @override
  State<EmergencyView> createState() => _EmergencyViewState();
}

class _EmergencyViewState extends State<EmergencyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Text("Ambulence"),
              IconButton(
                onPressed: () {
                  // ignore: deprecated_member_use
                  launch("tel:999");
                },
                icon: Icon(Icons.call),
              )
            ],
          ),
        ],
      ),
    );
  }
}
