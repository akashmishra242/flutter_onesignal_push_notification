import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initPlatform();
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId(oneSignalAppId); //put your onesignal APP ID
    await OneSignal.shared.getDeviceState().then((value) {
      log(value!.userId.toString());
    });
  }

  void sendNotificationToAllDevice(BuildContext context) async {
    var url = Uri.parse('$myIPV4Address/api/sendNotification');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        log("SUCCESS! Notification Sent to all devices.");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("SUCCESS! Notification Sent to all devices."),
            ),
          );
        }
      } else {
        log("Failed to send notification. Error code: ${response.statusCode}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Failed to send notification. Error code: ${response.statusCode}"),
            ),
          );
        }
      }
    } catch (e) {
      log("Failed to send notification. Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send notification. Error: $e"),
        ),
      );
    }
  }

  Future<void> sendNotificationToSelectedDevice() async {
    final url = Uri.parse('$myIPV4Address/api/sendNotificationToDevice');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'devices': ['61707e6e-21cc-483c-b169-6c0e663c5bd7'],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Request successful
      log('Notification sent successfully');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("SUCCESS! Notification Sent to selected devices."),
          ),
        );
      }
    } else {
      // Request failed
      log('Failed to send notification. Error code: ${response.statusCode}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${response.statusCode}"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OneSingal Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to (Flutter + node.js + onesignal) push notification demo',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                sendNotificationToAllDevice(context);
              },
              child: const Text('send notification to all devices'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                sendNotificationToSelectedDevice();
              },
              child: const Text('send notification to selected devices'),
            ),
          ],
        ),
      ),
    );
  }
}
