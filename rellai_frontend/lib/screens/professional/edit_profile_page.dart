// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// import 'package:rellai_frontend/models/user.dart';

// class EditProfilePage extends StatefulWidget {
//   final AppUser user;
//   const EditProfilePage({Key? key, required this.user}) : super(key: key);
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _businessNameController = TextEditingController();
//   String? _userImageURL;

//   void _saveProfile() {
//     // recupera i dati dai campi di testo e dall'URL dell'immagine
//     String? phoneNumber = _phoneNumberController.text;
//     String? businessName = _businessNameController.text;
//     String? address = _addressController.text;
//     String? imageURL = _userImageURL;

//     // chiama la funzione per inviare i dati del profilo al server
//     ProfileDataService.updateUserProfile(
//         phoneNumber, address, imageURL, businessName);

//     // torna alla schermata precedente
//     Navigator.pop(context);
//   }

//   void _setImageURL(String? imageURL) {
//     setState(() {
//       _userImageURL = imageURL;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//         actions: [
//           TextButton(
//             onPressed: _saveProfile,
//             child: const Text(
//               'Salva',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             ImageUploader(setImageURL: _setImageURL),
//             SizedBox(height: 20),
//             Text('Full Name', style: TextStyle(fontSize: 18)),
//             TextField(
//               enabled: false,
//               decoration: InputDecoration(
//                 hintText: widget.user.name,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Email', style: TextStyle(fontSize: 18)),
//             TextField(
//               enabled: false,
//               decoration: InputDecoration(
//                 hintText: widget.user.mail,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Numero di telefono', style: TextStyle(fontSize: 18)),
//             TextField(
//               controller: _phoneNumberController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 hintText: widget.user.phoneNumber ?? '+39 333 444 5555',
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Indirizzo', style: TextStyle(fontSize: 18)),
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 hintText:
//                     widget.user.address ?? 'Via, Numero Civico, Città, CAP',
//               ),
//               maxLines: null,
//             ),
//             SizedBox(height: 16),
//             if (widget.user.role == 'professional')
//               Column(
//                 children: [
//                   Text('Numero di telefono', style: TextStyle(fontSize: 18)),
//                   TextField(
//                     controller: _businessNameController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       hintText: '+39 333 444 5555',
//                     ),
//                   ),
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileDataService {
//   void updateUserProfile(String? phoneNumber, String? address, String? imageURL,
//       String? businessName) {
//     final CollectionReference users =
//         FirebaseFirestore.instance.collection('users');
//     final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

//     Map<String, dynamic> dataToUpdate = {};

//     if (phoneNumber != "") {
//       dataToUpdate['phoneNumber'] = phoneNumber;
//     }

//     if (address != "") {
//       dataToUpdate['address'] = address;
//     }
//     if (businessName != "") {
//       dataToUpdate['business_name'] = address;
//     }

//     if (imageURL != null) {
//       dataToUpdate['profile_image_url'] = imageURL;
//     }

//     users
//         .doc(userId)
//         .update(dataToUpdate)
//         .then((value) => print('Profilo utente aggiornato con successo'))
//         .catchError((error) => print(
//             'Errore durante l\'aggiornamento del profilo utente: $error'));
//   }
// }

// class ImageUploader extends StatefulWidget {
//   final void Function(String?) setImageURL;

//   const ImageUploader({Key? key, required this.setImageURL}) : super(key: key);

//   @override
//   _ImageUploaderState createState() => _ImageUploaderState();
// }

// class _ImageUploaderState extends State<ImageUploader> {
//   final ImagePicker _picker = ImagePicker();
//   File? _imageFile;
//   String? _imageURL;

//   Future<void> _getImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//       _uploadImage();
//     }
//   }

//   Future<void> _uploadImage() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user != null && _imageFile != null) {
//       final Reference storageRef = FirebaseStorage.instance
//           .ref()
//           .child('users/${user.uid}/profile_image');
//       final UploadTask uploadTask = storageRef.putFile(_imageFile!);
//       final TaskSnapshot downloadUrl = (await uploadTask);
//       final String url = (await downloadUrl.ref.getDownloadURL());
//       setState(() {
//         _imageURL = url;
//       });
//       widget.setImageURL(_imageURL);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: _getImage,
//           child: CircleAvatar(
//             radius: 50,
//             backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
//             child: _imageFile == null ? Icon(Icons.person, size: 50) : null,
//           ),
//         ),
//         SizedBox(height: 10),
//         TextButton(
//           onPressed: _getImage,
//           child: const Text(
//             'Cambia immagine',
//             style: TextStyle(color: Colors.blue),
//           ),
//         ),
//       ],
//     );
//   }
// }
