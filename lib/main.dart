import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  void _resetlistItems() {
    setState(() {
      _listItems = [];
      formController.text = "";
    });
  }

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
          Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                ),
                controller: formController,
                onFieldSubmitted: _submitlistItems,
              )),
          RaisedButton(
            onPressed: _addlistItems,
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.blueGrey,
                    Colors.blueGrey,
                  ],
                ),
              ),
              child: const Text('Add item to list',
                  style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: _listItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: stackBehindDismiss(),
                  key: ObjectKey(_listItems[index]),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _listItems[index],
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    var item = _listItems.elementAt(index);
                    //To delete
                    deleteItem(index);
                    //To show a snackbar with the UNDO button
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Item deleted"),
                        action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              //To undo deletion
                              undoDeletion(index, item);
                            })));
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _resetlistItems,
        tooltip: 'Reset',
        child: Icon(Icons.delete_sweep),
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
