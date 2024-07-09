import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Import for desktop support
import 'package:fluttergemini/classesfiles/routes.dart'; // Assuming this defines route names
import 'package:google_sign_in/google_sign_in.dart';
import 'google_sign_in_service.dart'; // Import the service

class LoginApp extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginApp> {
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await _googleSignInService.signInWithGoogle(context, Routes.Home);

    setState(() {
      _isLoading = false;
    });
  }

  void _skipLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.Home); // Replace with your home route name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, // Use the background color from the theme
      body: Stack(
        children: [
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile layout
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/newone.png',
                        height: 200, // Adjust image height as needed for mobile
                        fit: BoxFit.contain, // Ensure the image fits inside its container
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome to GeminiAI",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color for dark theme
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _handleGoogleSignIn(context),
                        icon: const Icon(Icons.mail),
                        label: const Text("Sign in with Google"),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25), // Reduced border radius
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () => _skipLogin(context),
                        child: const Text("Skip without login"),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25), // Reduced border radius
                            ),
                          ),
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                                (states) {
                              if (states.contains(MaterialState.hovered)) {
                                return const BorderSide(color: Colors.lightBlueAccent, width: 2);
                              }
                              return const BorderSide(color: Colors.lightBlue, width: 2);
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.lightBlue.withOpacity(0.1); // Light blue with opacity for hover
                              }
                              return Colors.transparent; // Transparent background by default
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Text color
                        ),
                      ),
                    ],
                  );
                } else {
                  // Desktop layout
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'assets/newone.png',
                          height: 300, // Adjust image height as needed for desktop
                          fit: BoxFit.contain, // Ensure the image fits inside its container
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Welcome to GeminiAI",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Text color for dark theme
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _handleGoogleSignIn(context),
                                  icon: const Icon(Icons.mail, size: 25,),
                                  label: const Text("Sign in with Google", style: TextStyle(fontSize: 20),),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                                    ),
                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25), // Reduced border radius
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                                  ),
                                ),
                                const SizedBox(width: 20),
                                OutlinedButton(
                                  onPressed: () => _skipLogin(context),
                                  child: const Text("Skip without login", style: TextStyle(fontSize: 20)),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                                    ),
                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25), // Reduced border radius
                                      ),
                                    ),
                                    side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return const BorderSide(color: Colors.lightBlueAccent, width: 2);
                                        }
                                        return const BorderSide(color: Colors.lightBlue, width: 2);
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return Colors.lightBlue.withOpacity(0.1); // Light blue with opacity for hover
                                        }
                                        return Colors.transparent; // Transparent background by default
                                      },
                                    ),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Text color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
