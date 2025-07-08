import 'package:bluebot/components/main_app_screen.dart';
import 'package:bluebot/data_store/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'dart:convert';
import 'package:bluebot/constants/backend.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool oauth1Complete = false;
  bool oauth2Complete = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> redirectToTwitter(String oauthToken) async {
    final twitterAuthUrl =
        'https://api.twitter.com/oauth/authorize?oauth_token=$oauthToken';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: twitterAuthUrl,
        callbackUrlScheme: 'bluebot',
      );

      final uri = Uri.parse(result);
      final verifier = uri.queryParameters['oauth_verifier'];
      final token = uri.queryParameters['oauth_token'];
      if (verifier != null && token != null) {
        final backendUri = Uri.parse("${backendUrl}/completeOauth1");

        try {
          final response = await http.post(
            backendUri,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'oauth_token': token,
              'oauth_verifier': verifier,
              'user_name': _usernameController.text.trim(),
            },
          );

          if (response.statusCode == 200) {
            setState(() {
              oauth1Complete = true;
            });
            loginComplete();
          }
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> handleLoginoAuth1() async {
    final uri = Uri.parse("${backendUrl}/loginIntent");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final oauth_token = response.body;
        redirectToTwitter(oauth_token);
      }
    } catch (_) {}
  }

  Future<void> handleAuthorizeUriOauth2(String url) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'bluebot',
      );

      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      final state = uri.queryParameters['state'];

      if (code != null) {
        final backendUri = Uri.parse("${backendUrl}/completeOauth2");

        try {
          final response = await http.post(
            backendUri,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'code': code,
              'state': state,
              'user_name': _usernameController.text.trim(),
            },
          );

          if (response.statusCode == 200) {
            setState(() {
              oauth2Complete = true;
            });
            loginComplete();
          }
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> handleLoginoAuth2() async {
    final Uri url = Uri.parse(
      '${backendUrl}/loginIntentOauth2?user_name=${_usernameController.text.trim()}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final authorizeUri = response.body;
        handleAuthorizeUriOauth2(authorizeUri);
      }
    } catch (_) {}
  }

  void loginComplete() {
    if (oauth1Complete && oauth2Complete) {
      UserStorage.saveUserSession(userName: _usernameController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainAppScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _topHeroSection(context),
              _loginInput(context),
              _termsText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(color: Color(0xFF0D0D1B)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/android_logo12.png",
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 8),
              const Text(
                "BlueBot",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Sign in to your\nAccount",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Don’t have an account? ",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "unique username",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleLoginoAuth1,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                "Log In Oauth1 [STEP1]",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleLoginoAuth2,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                "Log In Oauth2 [STEP2]",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Or login with"),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialAuthSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _socialButton(
            icon: FontAwesomeIcons.google,
            label: "Google",
            color: Colors.redAccent,
            onPressed: () {},
          ),
          _socialButton(
            icon: FontAwesomeIcons.facebookF,
            label: "Facebook",
            color: Colors.blue[800]!,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _termsText() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        "By signing up, you agree to the Terms of Service and Data Processing Agreement",
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
