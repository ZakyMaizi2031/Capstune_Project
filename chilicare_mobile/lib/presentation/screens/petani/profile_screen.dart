import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  Future _changePhoto() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() { _image = File(pickedFile.path); });
      // Panggil fungsi upload di repository/provider Anda di sini
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: Text("Profil Saya"), centerTitle: true),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null 
                    ? FileImage(_image!) 
                    : (user?.fotoProfil != null ? NetworkImage(user!.fotoProfil!) : null) as ImageProvider?,
                  child: user?.fotoProfil == null && _image == null 
                    ? Icon(Icons.person, size: 50, color: Colors.grey[600]) 
                    : null,
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: GestureDetector(
                    onTap: _changePhoto,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 18,
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(user?.namaLengkap ?? "User", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user?.email ?? "", style: TextStyle(color: Colors.grey)),
          Divider(height: 40),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Keluar Akun", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () { /* Fungsi Logout */ },
          )
        ],
      ),
    );
  }
}