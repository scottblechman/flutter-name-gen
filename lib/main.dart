import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new MyHomePage(title: 'Name Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _suggestions = <WordPair>[];

  final _savedSuggestions = new Set<WordPair>();

  // Create a list view item with a suggestion
  Widget _buildRow(WordPair pair) {
    // if the pair is saved then show the favorited status in the tile
    final isPairSaved = _savedSuggestions.contains(pair);

    return new ListTile(
      title: new Text(pair.asPascalCase, style: new TextStyle(fontSize: 18.0)
      ),
      // define the element to be at the end (trail) of the list item
      trailing: new Icon(
        isPairSaved ? Icons.favorite : Icons.favorite_border,
        color: isPairSaved ? Colors.red : null
      ),
      onTap: () {
        // toggle the tapped pair's state in the saved list and reflect in UI
        setState(() {
          if(isPairSaved) _savedSuggestions.remove(pair);
          else _savedSuggestions.add(pair);
        });
      }
    );
  }

  // creates the body of the main app, a list view alternating between word
  // and dividers
  Widget _buildSuggestionsList() {
   return new ListView.builder(
     padding: const EdgeInsets.all(16.0),
     // itemBuilder called once per wordpair and places into row
     // even rows get a word pair and odd rows get a divider widget
     itemBuilder: (context, i) {
       if(i.isOdd) return new Divider();

       //total number of word pairs is i/2
       final index = i ~/ 2;
       if(index >= _suggestions.length) {
         _suggestions.addAll(generateWordPairs().take(10));
       }
       return _buildRow(_suggestions[index]);
     }
   );
  }

  // creates a route (new screen) to show the current saved words
  void _showSaved() {
    // push a new route to the Navigator stack
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _savedSuggestions.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase, 
                  style: new TextStyle(fontSize: 18.0)
                  ),
              );
            }
          );
          final divided = ListTile.divideTiles(
            context: context, tiles: tiles
          ).toList();

          return new Scaffold(
            appBar: new AppBar(title: new Text('Favorite Names')
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        // define toolbar actions
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _showSaved)
        ],
      ),
      body: _buildSuggestionsList(),
    );
  }
}
