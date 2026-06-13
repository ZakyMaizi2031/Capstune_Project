import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/models/disease_model.dart';
import '../../../data/repositories/api_repository.dart';

class ManageDisease extends StatefulWidget {
  const ManageDisease({super.key});

  @override
  State<ManageDisease> createState() => _ManageDiseaseState();
}

class _ManageDiseaseState extends State<ManageDisease> {
  final ApiRepository _repo = ApiRepository();

  void _handleDelete(int id) async {
    bool success = await _repo.deleteDisease(id);
    if (success) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KELOLA ENSIKLOPEDIA")),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ChiliTheme.mintGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        onPressed: () {
          // Arahkan admin untuk buka web atau tampilkan pesan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gunakan Web Dashboard untuk menambah data penyakit baru"))
          );
        },
        label: const Text("TAMBAH DATA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<DiseaseModel>>(
        future: _repo.getEncyclopedia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final diseases = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              final disease = diseases[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: ChiliTheme.popArtDecoration(),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    disease.namaPenyakit.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text("Penyebab: ${disease.penyebab}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever, color: ChiliTheme.tomatoRed, size: 30),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text("Hapus Penyakit?"),
                          content: Text("Data ${disease.namaPenyakit} akan dihapus permanen."),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c), child: const Text("BATAL")),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(c);
                                _handleDelete(disease.idPenyakit);
                              },
                              child: const Text("HAPUS", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
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
