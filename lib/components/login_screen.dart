import 'package:bluebot/components/main_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _topHeroSection(context),
            _loginInput(context),
            _socialAuthSection(),
            _termsText(),
          ],
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
            onTap: () {
              // navigate to signup
            },
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
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (v) {}),
                  const Text("Remember Me"),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // forgot password action
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainAppScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text("Log In", style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
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
