import 'package:cloud_firestore/cloud_firestore.dart';

class FridgeService {

  retrieveGroup(String foodCat)  {
    return Firestore.instance
    .collection('Fridge')
    .where('foodCat', isEqualTo: foodCat)
    .getDocuments()
    .whenComplete(() => print(foodCat));
  }

    retrieveFood(String foodName, String foodCat)  {
    return Firestore.instance
    .collection('Fridge')
    .where('foodName', isEqualTo: foodName)
    .where('foodCat', isEqualTo: foodCat)
    .getDocuments()
    .whenComplete(() => print(foodName + foodCat));
  }


}