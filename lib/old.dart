import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.

        primarySwatch: Colors.blueGrey,
      ),
      home: Home(title: 'Groceries'),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listItems = [];

  void _addlistItems() {
    setState(() {
      _listItems.add(formController.text);
      formController.text = "";
    });
  }

  void _submitlistItems(text) {
    setState(() {
      _listItems.add(text);
      formController.text = "";
    });
  }

  final formController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ...(_listItems as List<dynamic>).map((item) {
            var i = _listItems.indexOf(item);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _listItems.remove(item);
                });
              },
              onPanUpdate: (details) {
                if (details.delta.dx > 0) {
                  setState(() {
                    _listItems.remove(item);
                  });
                }
              },
              child: Text(
                item,
                style: Theme.of(context).textTheme.display1,
              ),
            );
          }).toList(),
          TextFormField(
            // The validator receives the text that the user has entered.
            controller: formController,
            onFieldSubmitted: _submitlistItems,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addlistItems,
        tooltip: 'Add item',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void deleteItem(index) {
    /*
    By implementing this method, it ensures that upon being dismissed from our widget tree, 
    the item is removed from our list of items and our list is updated, hence
    preventing the "Dismissed widget still in widget tree error" when we reload.
    */
    setState(() {
      _listItems.removeAt(index);
    });
  }

  void undoDeletion(index, item) {
    /*
    This method accepts the parameters index and item and re-inserts the {item} at
    index {index}
    */
    setState(() {
      _listItems.insert(index, item);
    });
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
