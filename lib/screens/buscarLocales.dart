import 'package:flutter/material.dart';

class LocalesScreen extends StatefulWidget{
  @override
  _LocalesScreenState createState() => _LocalesScreenState();
}

class _LocalesScreenState extends State<LocalesScreen> {
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