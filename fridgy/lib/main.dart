import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fridgy/widgets/nav_drawer.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(MaterialApp(    
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey[400],
      accentColor: Colors.lightBlue[100]
    ) ,
    home: FirstPage(),
  ));
}


class VeggiesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Fridge').where('foodCat', isEqualTo: 'Veggie').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['foodName']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class FruitsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Fridge').where('foodCat', isEqualTo: 'Fruit').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['foodName']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class MeatList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Fridge').where('foodCat', isEqualTo: 'Meat').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['foodName']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class DairyList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Fridge').where('foodCat', isEqualTo: 'Dairy').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['foodName']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class FreezerList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Fridge').where('foodCat', isEqualTo: 'Freezer').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['foodName']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class MiscellaneousList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Fridge').where('foodCat', isEqualTo: 'Miscellaneous').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              shrinkWrap: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['foodName']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class FirstPage extends StatelessWidget{

  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
  static DateTime now = new DateTime.now();
  static var formatter = new DateFormat('dd-MM-yyyy');
  
  String foodName = "";
  String formattedDate = formatter.format(now);
  String foodCat = null;
  String groupName = '';

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
   
  createFood(){
    DocumentReference documentReference = Firestore.instance.collection("Fridge").document(foodName);
      Map<String, String> food = {
        "foodName": foodName,
        "purchaseDate": formattedDate,
        "foodCat": foodCat
        };
    documentReference.setData(food).whenComplete(() => print("$foodName created"));
  }

  removeFood(item){
    DocumentReference documentReference = Firestore.instance.collection("Fridge").document(item);
      documentReference.delete().whenComplete(() => print("$item deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text("fridgy"),
      ),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blueGrey[200],
      onPressed: () {
Alert(
                  context: context,
                  title: "Add Food",
                  desc: "Please insert name and category",
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Food name"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This cannot be empty';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                foodName = value;
                              }),
                          DropdownButton<String>(
                            value: foodCat,
                            isDense: true,
                            items: <String>[
                              'Meat',
                              'Veggies',
                              'Dairy',
                              'Fruit',
                              'Miscellaneous'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              foodCat = value;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    );
                  }),
                  buttons: [
                    DialogButton(
                        child: Text("Add to fridge"),
                        color: Colors.blueGrey[200],
                        onPressed: () {
                          if (!_formkey.currentState.validate()) {
                            Navigator.pop(context);
                                Alert(context: context, title: "ERROR", desc: "You need to insert a valid food.", buttons: [
            DialogButton(
              child: Text(
                "COOL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(91, 55, 185, 1.0),
              radius: BorderRadius.circular(10.0),
            ),
          ],)
                            .show();
                          } else {
                            Navigator.pop(context);
                            return createFood();
                          }                    
                        })
                  ]).show();
              },
              child: Icon(Icons.add),
            ),      
       body:  StreamBuilder(stream: Firestore.instance.collection("Fridge").snapshots(),
        builder: (context, snapshots){
          if(snapshots.data == null) return ListView(); //Check if data snapshots is null
           return ListView.builder(
             shrinkWrap: true,
             itemCount: snapshots.data.documents.length,
             itemBuilder: (context, index){
               DocumentSnapshot documentSnapshot = snapshots.data.documents[index];
               return Dismissible(
                 onDismissed: (direction)  {
                  removeFood(documentSnapshot["foodName"]);
                 },
                 key: Key(documentSnapshot["foodName"]), 
                 child: Card(
                   elevation: 4,
                   margin: EdgeInsets.all(8),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8)
                   ),
                   child: new Column(mainAxisSize: MainAxisSize.min, 
                    children: <Widget>[
                      new ListTile(
                     leading: Icon(Icons.fastfood),
                     title: Text(documentSnapshot["foodName"] ?? ''), //Check if the string input is null
                     subtitle: Text("Purchase Date: " + documentSnapshot["purchaseDate"] ?? ''),
                     //isThreeLine: true,
                     dense: true,
                     trailing: IconButton(icon: Icon(Icons.delete_sweep,
                     color: Colors.blueGrey[400]), 
                     onPressed: (){
                      removeFood(documentSnapshot["foodName"]);
                       }//OnPress action
                     ) ,
                     ),
                    ]
                 )
                 )
                );
             }
           );
        },
       ),
    );
  }
}

class SecondPage extends StatelessWidget {

  String groupName = '';
  final TextEditingController controller = new TextEditingController();

  createGroup(){
    DocumentReference documentReference = Firestore.instance.collection("FoodCluster").document(groupName);
      Map<String, String> group = {
        "groupName": groupName
        };
    documentReference.setData(group).whenComplete(() => print("$groupName Group created"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Drawer"),
      ),
      body: Column(
        children: <Widget>[
          ExpansionTile(title: Text('Veggies'),
          children: <Widget>[
            new VeggiesList()
          ]
         ),
         ExpansionTile(title: Text('Fruits'),
          children: <Widget>[
            new FruitsList()
          ]
         ),
         ExpansionTile(title: Text('Meat'),
          children: <Widget>[
            new MeatList()
          ]
         ),
         ExpansionTile(title: Text('Dairy'),
          children: <Widget>[
            new DairyList()
          ]
         ),
         ExpansionTile(title: Text('Freezer'),
          children: <Widget>[
            new FreezerList()
          ]
         ),
         ExpansionTile(title: Text('Miscellaneous'),
          children: <Widget>[
            new MiscellaneousList()
          ]
         )
        ]
      )
    );
  }
}