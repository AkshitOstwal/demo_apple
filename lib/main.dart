import 'dart:io';

import 'package:flutter/material.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      apple.AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: apple.AppleSignInButton(
          style: apple.ButtonStyle.black,
          type: apple.ButtonType.continueButton,
          onPressed: appleLogIn,
        ),
      ),
    );
  }

  appleLogIn() async {
    if (await apple.AppleSignIn.isAvailable()) {
      //Check if Apple SignIn isn available for the device or not
    } else {
      print('Apple SignIn is not available for your device');
    }
    if (await apple.AppleSignIn.isAvailable()) {
      final apple.AuthorizationResult result =
          await apple.AppleSignIn.performRequests([
        apple.AppleIdRequest(
            requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);
      switch (result.status) {
        case apple.AuthorizationStatus.authorized:
          print(result.credential.user); //All the required credentials
          break;
        case apple.AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case apple.AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }
}
