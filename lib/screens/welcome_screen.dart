import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final headingStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    final subheadingStyle = TextStyle(
      fontSize: 18,
      color: theme.colorScheme.onPrimaryContainer,
    );

    final darkButtonStyle = ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primary),
        foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimary));

    void navigateToHomePage() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyHomePage()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.abc,
                      size: 200,
                    ),
                    Text(
                      "Welcome Back!",
                      style: headingStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Let's get logged in so you can start finding cool names!",
                        style: subheadingStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Sign Up'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {navigateToHomePage();},
                        style: darkButtonStyle,
                        child: Text('Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
