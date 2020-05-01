import 'package:diefpc/app/app.dart';
import 'package:flutter/material.dart';


//Punto de entrada para su aplicación
void main() => runApp(MyApp());

/*
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: RandomWords(),
      );
  }
}

class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
 @override
 final List<WordPair>_suggestions = <WordPair>[];
 final Set<WordPair> _saved = Set<WordPair>();
 final TextStyle _biggerFont = TextStyle(fontSize: 18.0);
 Widget build(BuildContext context){
   return Scaffold(
     appBar: AppBar(
       title: Text('Testing palabras\nAleatorias'),
       actions: <Widget>[
         IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
       ],
     ),
     body: _buildSuggestions(),
     backgroundColor: Colors.white70,
   );
 }
 Widget _buildSuggestions(){
   return ListView.builder(
     padding: const EdgeInsets.all(16.0),
     itemBuilder: /*1*/(context,i){
       if(i.isOdd) return Divider();/*2*/
       final index = i ~/ 2; /*3*/
       if(index >= _suggestions.length){
         _suggestions.addAll(generateWordPairs().take(10)); /*4*/
       }
       return _buildRow(_suggestions[index]);
     });
 }
 Widget _buildRow(WordPair pair){
   final bool alreadySaved = _saved.contains((pair));
   return ListTile(
     title: Text(
       pair.asPascalCase,
       style: _biggerFont,
     ),
     trailing: Icon(
       alreadySaved ? Icons.favorite : Icons.favorite_border,
       color: alreadySaved ? Colors.blue : null,
     ),
     onTap: (){
       setState(() {
         if(alreadySaved){
           _saved.remove(pair);
         }else{
           _saved.add(pair);
         }
       });
     },
   );
 }
 */
/*
 void _pushSaved(){
   Navigator.of(context).push(
     MaterialPageRoute<void>(
       builder: (BuildContext context){
           final Iterable<ListTile> tiles = _saved.map(
               (WordPair pair){
                 return ListTile(
                   title: Text(
                     pair.asPascalCase,
                     style: _biggerFont,
                 ),
                 );
               },
           );
           final List<Widget> divided = ListTile
               .divideTiles(
               context: context,
               tiles: tiles,
           )
         .toList();
         return Scaffold(
           appBar: AppBar(
              title: _saved.length != 0 ? Text('Guardados') : Text('Aún no has\nGuardado nada'),
           ),
           body: ListView(children: divided),
           backgroundColor: Colors.cyanAccent,

         );
       },
     ),
   );
 }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIEFP-C',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Página Principal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Has apretado:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/