import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _log = '';
  final _apiKey = TextEditingController();
  final _cluster = TextEditingController();
  final _channelName = TextEditingController();
  final _eventName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _listViewController = ScrollController();

  void log(String text) {
    print("LOG: $text");
    setState(() {
      _log += text + "\n";
      Timer(
          const Duration(milliseconds: 100),
          () => _listViewController
              .jumpTo(_listViewController.position.maxScrollExtent));
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onConnectPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Remove keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("apiKey", _apiKey.text);
    prefs.setString("cluster", _cluster.text);
    prefs.setString("channelName", _channelName.text);
    prefs.setString("eventName", _eventName.text);

    try {
      await PusherChannelsFlutter.init(
          apiKey: _apiKey.text,
          cluster: _cluster.text,
          onConnectionStateChange: onConnectionStateChange,
          onError: onError,
          onSubscriptionSucceeded: onSubscriptionSucceeded,
          onEvent: onEvent,
          onAuthenticationFailure: onAuthenticationFailure,
          onDecryptionFailure: onDecryptionFailure,
          userSubscribed: userSubscribed,
          userUnsubscribed: userUnsubscribed,
          onUsersInformationReceived: onUsersInformationReceived);
      await PusherChannelsFlutter.subscribe(
          channelName: _channelName.text, eventName: _eventName.text);
      await PusherChannelsFlutter.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  void onConnectionStateChange(currentState, previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int code, String e) {
    log("onError: $message code: $code exception: $e");
  }

  void onEvent(Object event) {
    log("onEvent: $event");
  }

  void onSubscriptionSucceeded(String channelName) {
    log("onSubscriptionSucceeded: $channelName");
  }

  void onAuthenticationFailure(String message, String e) {
    log("onAuthenticationFailure: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void userSubscribed(String channelName, user) {
    log("userSubscribed: $channelName user: $user");
  }

  void userUnsubscribed(String channelName, user) {
    log("userUnsubscribed: $channelName user: $user");
  }

  void onUsersInformationReceived(String channelName, users) {
    log("onUsersInformationReceived: $channelName users: $users");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey.text = prefs.getString("apiKey") ?? '';
      _cluster.text = prefs.getString("cluster") ?? '';
      _channelName.text = prefs.getString("channelName") ?? '';
      _eventName.text = prefs.getString("eventName") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pusher Channels Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
                controller: _listViewController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    controller: _apiKey,
                    validator: (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'Please enter your API key.'
                          : null;
                    },
                    //onSaved: (String? value) { _apiKey = value!; },
                    decoration: const InputDecoration(labelText: 'API Key'),
                  ),
                  TextFormField(
                    controller: _cluster,
                    validator: (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'Please enter your cluster.'
                          : null;
                    },
                    //onSaved: (String? value) { _cluster = value!; },
                    decoration: const InputDecoration(
                      labelText: 'Cluster',
                    ),
                  ),
                  TextFormField(
                    controller: _channelName,
                    validator: (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'Please enter your channel name.'
                          : null;
                    },
                    //onSaved: (String? value) { _channelName = value!; },
                    decoration: const InputDecoration(
                      labelText: 'Channel',
                    ),
                  ),
                  TextFormField(
                    controller: _eventName,
                    validator: (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'Please enter your event name.'
                          : null;
                    },
                    //onSaved: (String? value) { _eventName = value!; },
                    decoration: const InputDecoration(
                      labelText: 'Event',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onConnectPressed,
                    child: const Text('Connect'),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.vertical, child: Text(_log)),
                ]),
          ),
        ),
      ),
    );
  }
}
