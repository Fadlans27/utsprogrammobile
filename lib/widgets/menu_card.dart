import 'package:flutter/material.dart';
import '../../data_menu.dart';

class ItemMenuCard extends StatelessWidget {
  final Map<String, dynamic> menu;
  final VoidCallback onTambah;

  const ItemMenuCard({
    super.key,
    required this.menu,
    required this.onTambah,
  });

  @override
  Widget build(BuildContext context) {
    final nama = menu['nama'].toString();
    final harga = menu['harga'] as int;
    final emoji = menu['emoji'].toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 28)),
        title: Text(
          nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formatRupiah(harga)),
        trailing: FilledButton(
          onPressed: onTambah,
          child: const Text('Tambah'),
        ),
      ),
    );
  }
}