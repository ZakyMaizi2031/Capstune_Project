import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
// import '../../../data/models/disease_model.dart';
import '../../providers/encyclopedia_provider.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Mengambil data dari backend saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EncyclopediaProvider>(context, listen: false).fetchDiseases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChiliTheme.lemonYellow,
      appBar: AppBar(
        title: const Text("ENSIKLOPEDIA CABAI"),
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR POP-ART
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: ChiliTheme.popArtDecoration(color: Colors.white),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Cari penyakit atau gejala...",
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ),

          // 2. DAFTAR PENYAKIT (LIST VIEW)
          Expanded(
            child: Consumer<EncyclopediaProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: ChiliTheme.tomatoRed));
                }

                // Filter data berdasarkan input search
                final filteredList = provider.diseases.where((d) {
                  final name = (d['namaPenyakit'] ?? '').toString().toLowerCase();
                  final gejala = (d['gejalaVisual'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery) || gejala.contains(_searchQuery);
                }).toList();

                if (filteredList.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                  final disease = filteredList[index];
                    // Warna selang-seling agar ceria (Pop-Art style)
                    final List<Color> cardColors = [
                      ChiliTheme.mintGreen,
                      Colors.orangeAccent,
                      Colors.lightBlueAccent,
                      const Color(0xFFF08080) // Light Coral
                    ];
                    
                    return _buildDiseaseCard(
                      disease['namaPenyakit'] ?? 'Unknown',
                      disease['penyebab'] ?? 'Unknown',
                      disease['gejalaVisual'] ?? 'Unknown',
                      cardColors[index % cardColors.length],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Kartu Penyakit Pop-Art
  Widget _buildDiseaseCard(String name, String cause, String gejala, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: ChiliTheme.popArtDecoration(color: color),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Icon(Icons.bug_report_outlined, size: 35, color: Colors.black),
        ),
        title: Text(
          name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "Penyebab: $cause",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
        onTap: () {
          _showDetailBottomSheet(context, name, cause, gejala);
        },
      ),
    );
  }

  // MODAL DETAIL: Menampilkan Gejala & Rekomendasi
  void _showDetailBottomSheet(BuildContext context, String name, String cause, String gejala) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(top: BorderSide(color: Colors.black, width: 4)),
        ),
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Text(name.toUpperCase(), style: ChiliTheme.headerTitle),
              Text("Penyebab: $cause", style: const TextStyle(color: ChiliTheme.tomatoRed, fontWeight: FontWeight.bold)),
              const Divider(height: 40, thickness: 2, color: Colors.black),
              
              const Text("GEJALA VISUAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(gejala, style: const TextStyle(fontSize: 15, height: 1.5)),
              
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintGreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.black),
                        SizedBox(width: 10),
                        Text("REKOMENDASI PENANGANAN", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Data rekomendasi akan ditampilkan setelah backend diintegrasikan."),
                    const SizedBox(height: 10),
                    Text("OBAT DISARANKAN: Konsultasikan dengan ahli", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Color(0x3D000000)), // Colors.black with 24% opacity
          const SizedBox(height: 10),
          Text("Penyakit tidak ditemukan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
        ],
      ),
    );
  }
}