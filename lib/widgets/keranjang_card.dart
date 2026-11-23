import 'package:flutter/material.dart';
import '../data_menu.dart';

class ItemKeranjangCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onKurang;
  final VoidCallback onTambah;
  final VoidCallback onHapus;

  const ItemKeranjangCard({
    super.key,
    required this.item,
    required this.onKurang,
    required this.onTambah,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final nama = item['nama'].toString();
    final emoji = item['emoji'].toString();
    final qty = item['qty'] as int;
    final harga = item['harga'] as int;
    final subtotalItem = qty * harga;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text('x$qty  •  ${formatRupiah(subtotalItem)}'),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Kurangi jumlah',
              onPressed: onKurang,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              tooltip: 'Tambah jumlah',
              onPressed: onTambah,
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              tooltip: 'Hapus item',
              onPressed: onHapus,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}