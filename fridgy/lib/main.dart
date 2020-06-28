import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fridgy/widgets/nav_drawer.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey[400],
      accentColor: Colors.lightBlue[100]
    ) ,
    home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String foodName = "";
  static DateTime now = new DateTime.now();
  static var formatter = new DateFormat('dd-MM-yyyy');
  String formattedDate = formatter.format(now);

  createFood(){
    DocumentReference documentReference = Firestore.instance.collection("Fridge").document(foodName);
      Map<String, String> food = {
        "foodName": foodName
        };
    documentReference.setData(food).whenComplete(() => print("$foodName created"));
  }

  removeFood(item){
    DocumentReference documentReference = Firestore.instance.collection("Fridge").document(item);
      documentReference.delete().whenComplete(() => print("$foodName deleted"));
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
        showDialog(context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            title: Text("Add Food to fridge"),
            content: TextField(
              onChanged: (String value){
                foodName = value;
              }
            ),
            actions: <Widget>[
              FlatButton(onPressed:  (){
                createFood();
                Navigator.of(context).pop();
              }, child: Text("Add"))
            ],
          );
        });
      },
      child: Icon(Icons.add, 
        color: Colors.white, 
        ),
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
                   child: ListTile(
                     title: Text(documentSnapshot["foodName"] ?? ''), //Check if the string input is null
                     subtitle: Text("Purchase Date:" + " " + formattedDate.toString()),
                     dense: true,
                     trailing: IconButton(icon: Icon(Icons.delete_sweep,
                     color: Colors.blueGrey[400]), 
                     onPressed: (){
                       removeFood(documentSnapshot["foodName"]);
                       }//OnPress action
                     ) ,
                     ),
                 )
                );
             }
           );
        },
       ),
    );
  }
}