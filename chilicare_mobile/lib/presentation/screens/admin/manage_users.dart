import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/api_repository.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final ApiRepository _repo = ApiRepository();

  // Fungsi untuk menghapus user
  void _confirmDelete(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 3),
        ),
        title: const Text("Hapus User?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin menghapus ${user.namaLengkap}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("BATAL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ChiliTheme.tomatoRed),
            onPressed: () async {
              await _repo.deleteUser(user.idUser);
              Navigator.pop(context);
              setState(() {}); // Refresh list
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User berhasil dihapus")));
            },
            child: const Text("HAPUS", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KELOLA PENGGUNA")),
      body: FutureBuilder<List<UserModel>>(
        future: _repo.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: ChiliTheme.popArtDecoration(
                  color: user.isAdmin ? ChiliTheme.mintGreen : Colors.white,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(user.namaLengkap[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  title: Text(user.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user.email),
                  trailing: user.isAdmin 
                    ? const Icon(Icons.verified_user, color: Colors.blue)
                    : IconButton(
                        icon: const Icon(Icons.delete_outline, color: ChiliTheme.tomatoRed),
                        onPressed: () => _confirmDelete(user),
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
