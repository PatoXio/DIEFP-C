import 'package:flutter/material.dart';

class LocalesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locales Cercanos"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Deberían mostrar los locales'),
        ),
      ),
    );
  }
}