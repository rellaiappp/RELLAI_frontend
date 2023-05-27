import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rellai_frontend/services/api/user.dart';
import 'package:rellai_frontend/providers/user_provider.dart';
import 'package:rellai_frontend/models/user.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  String? _userImageURL;

  void _saveProfile(context) async {
    AppUser updatedUser = widget.user;
    // recupera i dati dai campi di testo e dall'URL dell'immagine
    updatedUser.phone = _phoneNumberController.text;

    if (_businessNameController.text != "") {
      updatedUser.businessInfo =
          BusinessInfo(businessName: _businessNameController.text);
    }
    if (_addressController.text != "") {
      updatedUser.address = Address(
          street: _addressController.text,
          city: _cityController.text,
          region: _regionController.text,
          state: "Italy",
          zipCode: "");
    }
    if (_userImageURL != null) updatedUser.profileImageUrl = _userImageURL;
    UserCRUD().updateUser(updatedUser);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateUser();
    const snackBar = SnackBar(
      content: Text('Utente aggiornato con successo!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  void _setImageURL(String? imageURL) {
    setState(() {
      _userImageURL = imageURL;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = "${widget.user.firstName} ${widget.user.lastName}";
    _mailController.text = widget.user.email;
    _phoneNumberController.text = widget.user.phone ?? "";
    _businessNameController.text = widget.user.businessInfo?.businessName ?? "";
    _cityController.text = widget.user.address?.city ?? "";
    _regionController.text = widget.user.address?.region ?? "";
    _addressController.text = widget.user.address?.street ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica profilo'),
        actions: [
          TextButton(
            onPressed: () {
              _saveProfile(context);
            },
            child: const Text(
              'Salva',
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _nameController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: '${widget.user.firstName} ${widget.user.lastName}',
                  label: const Text('Nome'),
                ),
              ),
              TextField(
                controller: _mailController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: widget.user.email,
                  label: const Text('Email'),
                ),
              ),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: widget.user.phone ?? '+39 333 444 5555',
                  label: const Text('Numero di telefono'),
                ),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  label: const Text('Indirizzo'),
                  hintText:
                      widget.user.address?.street ?? 'Via, Numero Civico,',
                ),
                maxLines: null,
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: widget.user.address?.city ?? 'Città',
                  label: const Text('Città'),
                ),
                maxLines: null,
              ),
              TextField(
                controller: _regionController,
                decoration: InputDecoration(
                    hintText: widget.user.address?.region ?? 'Provincia',
                    label: const Text('Provincia')),
                maxLines: null,
              ),
              if (widget.user.role == 'business')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _businessNameController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: widget.user.businessInfo?.businessName ??
                              'Nome impresa',
                          label: const Text('Nome impresa')),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDataService {
  void updateUserProfile(String? phoneNumber, String? address, String? imageURL,
      String? city, String? region, String? businessName) {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    Map<String, dynamic> dataToUpdate = {};

    if (phoneNumber != "") {
      dataToUpdate['phone_number'] = phoneNumber;
    }

    if (address != "") {
      dataToUpdate['address'] = address;
    }
    if (address != "") {
      dataToUpdate['cuty'] = city;
    }
    if (businessName != "") {
      dataToUpdate['region'] = region; // Fix this line
    }
    if (businessName != "") {
      dataToUpdate['business_name'] = businessName; // Fix this line
    }
    if (imageURL != null) {
      dataToUpdate['profile_image_url'] = imageURL;
    }

    users.doc(userId).update(dataToUpdate).catchError((error) =>
        print('Errore durante l\'aggiornamento del profilo utente: $error'));
  }
}

class ImageUploader extends StatefulWidget {
  final void Function(String?) setImageURL;

  const ImageUploader({Key? key, required this.setImageURL}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _imageURL;

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _imageFile != null) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/profile_image');
      final UploadTask uploadTask = storageRef.putFile(_imageFile!);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = (await downloadUrl.ref.getDownloadURL());
      setState(() {
        _imageURL = url;
      });
      widget.setImageURL(_imageURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _getImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child:
                _imageFile == null ? const Icon(Icons.person, size: 50) : null,
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _getImage,
          child: const Text(
            'Cambia immagine',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
