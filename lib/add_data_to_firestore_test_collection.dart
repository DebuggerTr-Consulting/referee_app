import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referee_aplication/get_device_info.dart';
import 'models/device_info_model.dart'; 

Future<void> addDataToFirestoreTestCollection(int counterValue) async {

  MyAppDeviceInfo deviceInfo = await getDeviceInfo2();

  // 1. Get the Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 2. Get a reference to the 'test' collection
  CollectionReference testCollectionRef = firestore.collection('test');

  // 3. Prepare the data you want to add.
  //    It should be a Map where keys are Strings and values can be dynamic (Strings, numbers, booleans, maps, lists, null).
  Map<String, dynamic> dataToAdd = {
    'numara': '$counterValue', // Using the counter value you mentioned
    'timestamp': FieldValue.serverTimestamp(), // Good practice to add a server timestamp
    'description': 'This is a test document from Flutter',
     'adi': 'Mustafa',
     'deviceInfo': deviceInfo.toMap(), // Cihaz bilgisini Map olarak kaydedin
      };

    // Add other fields as needed
  debugPrint('Attempting to add document with data: $dataToAdd');

  // 4. Add the document to the collection
  try {

    debugPrint('--> Executing testCollectionRef.add...'); // Add this line

    DocumentReference docRef = await testCollectionRef.add(dataToAdd);

     debugPrint('<-- testCollectionRef.add completed.'); // Add this line - DO YOU SEE THIS?

    // If successful, the Future resolves and we get the DocumentReference
    debugPrint("Document added successfully!");
    debugPrint("Document ID: ${docRef.id}");

  } catch (e) {
    // If there's an error, the Future throws an exception
    debugPrint("Failed to add document to Firestore: $e");

    // Pay close attention to the error message here!
    // It will often tell you exactly what went wrong.
    // Common errors include:
    // - Permissions denied (Firestore Security Rules are preventing the write)
    // - Invalid data format
    // - Network issues
    // - Firebase not initialized
  }

   String myCustomUserId = 'user12345';

     addDocumentWithCustomId(myCustomUserId, dataToAdd);


}


Future<void> addDocumentWithCustomId(String customDocId, Map<String, dynamic> data) async {
  // 1. Firestore instance'ını alın
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 2. 'test' koleksiyonuna referans alın
  CollectionReference testCollectionRef = firestore.collection('test');

  // 3. Belge ID'sini belirtmek için .doc() methodunu kullanın
  DocumentReference documentRef = testCollectionRef.doc(customDocId);

  // 4. Veriyi bu belge referansına .set() methodu ile yazın
  // set() methodu, eğer belge yoksa oluşturur, varsa üzerine yazar.
  // Eğer sadece yeni belge oluşturmak ve varsa hata vermek isterseniz set(data, SetOptions(merge: false)) kullanabilirsiniz.
  // Ancak genellikle set() tek başına yeterlidir.
  debugPrint('Attempting to set document with ID: $customDocId and data: $data');

  try {
    await documentRef.set(data);

    // set() methodu void döndürür ve başarılı olunca Future tamamlanır.
    debugPrint("Document successfully set with custom ID: $customDocId");

  } catch (e) {
    // Hata oluşursa yakalanır
    debugPrint("Failed to set document with custom ID $customDocId: $e");

    // Olası hatalar:
    // - İzin hatası (Firestore Security Rules)
    // - Geçersiz veri formatı
    // - Ağ sorunları
  }
}