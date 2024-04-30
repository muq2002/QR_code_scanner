import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildKeypad(context),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_pinController.text == '1234') {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect PIN')),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create the custom keypad
  Widget buildKeypad(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(12, (index) {
        String buttonText;
        VoidCallback onPressed;

        if (index < 9) {
          // Number buttons 1-9
          buttonText = (index + 1).toString();
          onPressed = () {
            _pinController.text += buttonText;
          };
        } else if (index == 9) {
          // Empty button for grid alignment
          buttonText = '';
          onPressed = () {};
        } else if (index == 10) {
          // Number button 0
          buttonText = '0';
          onPressed = () {
            _pinController.text += buttonText;
          };
        } else {
          // Backspace button
          buttonText = '⌫';
          onPressed = () {
            if (_pinController.text.isNotEmpty) {
              _pinController.text = _pinController.text
                  .substring(0, _pinController.text.length - 1);
            }
          };
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText, style: TextStyle(fontSize: 24)),
          ),
        );
      }),
    );
  }
}
