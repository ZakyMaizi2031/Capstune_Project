import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../../providers/history_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/history_model.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final userId = auth.user?.idUser;
      if (userId != null) {
        Provider.of<HistoryProvider>(context, listen: false).fetchMyHistory(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    // final auth = Provider.of<AuthProvider>(context, listen: false);

    final items = historyProvider.myHistory;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('RIWAYAT DETEKSI', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: historyProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ChiliTheme.tomatoRed),
            )
          : items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history_toggle_off_rounded, size: 90, color: Color(0x3D000000)),
                      const SizedBox(height: 10),
                      Text(
                        'Belum ada riwayat, silakan scan terlebih dahulu.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final HistoryModel item = items[index];
                    return _HistoryCard(item: item);
                  },
                ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistoryModel item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintSoft),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item.namaPenyakit?.toUpperCase() ?? item.hasilPrediksi.toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Text(
                  item.formattedAkurasi,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tanggal: ${item.formattedDate}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          // Foto input scan
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              item.fileFotoInput,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image_rounded, size: 40, color: Colors.black54),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

