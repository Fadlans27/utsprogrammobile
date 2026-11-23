import 'package:flutter/material.dart';

import 'data_menu.dart';
import 'widgets/keranjang_card.dart';
import 'widgets/menu_card.dart';

void main() => runApp(const KantinDigitalApp());

class KantinDigitalApp extends StatelessWidget {
  const KantinDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kantin Digital Kampus',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0D47A1),
        useMaterial3: true,
      ),
      home: const KantinHomePage(),
    );
  }
}

class KantinHomePage extends StatefulWidget {
  const KantinHomePage({super.key});

  @override
  State<KantinHomePage> createState() => _KantinHomePageState();
}

class _KantinHomePageState extends State<KantinHomePage> {
  static const String _namaMahasiswa = 'Ahmad Fadlan';
  static const String _npmMahasiswa = '2410020021';
  static const String _kelasMahasiswa =
      '5A Sistem Informasi NonReguler Banjarbaru';

  final TextEditingController _searchCtrl = TextEditingController();
  int _selectedNavIndex = 0;
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  final List _keranjang = [];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _inisialDariNama(String nama) {
    final bagianKata = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((kata) => kata.isNotEmpty)
        .toList();

    if (bagianKata.isEmpty) return 'M';
    if (bagianKata.length == 1) {
      return bagianKata[0][0].toUpperCase();
    }
    return '${bagianKata[0][0]}${bagianKata[1][0]}'.toUpperCase();
  }

  int get _jumlahItem {
    int totalQty = 0;
    for (final item in _keranjang) {
      totalQty += (item['qty'] as int);
    }
    return totalQty;
  }

  int get _subtotalKeranjang {
    int total = 0;
    for (final item in _keranjang) {
      total += (item['harga'] as int) * (item['qty'] as int);
    }
    return total;
  }

  int get _potonganDiskon {
    final subtotal = _subtotalKeranjang;
    if (subtotal >= 50000) {
      return (subtotal * 0.1).round();
    }
    return 0;
  }

  int get _totalAkhir {
    return _subtotalKeranjang - _potonganDiskon;
  }

  void _showSnack(String pesan, {Color? warna}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: warna ?? const Color(0xFF0D47A1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _tambahKeKeranjang(Map<String, dynamic> menu) {
    setState(() {
      final indexAda = _keranjang.indexWhere(
        (item) => item['id'] == menu['id'],
      );
      if (indexAda != -1) {
        _keranjang[indexAda]['qty'] = (_keranjang[indexAda]['qty'] as int) + 1;
      } else {
        _keranjang.add({
          'id': menu['id'],
          'nama': menu['nama'],
          'harga': menu['harga'],
          'emoji': menu['emoji'],
          'qty': 1,
        });
      }
    });

    _showSnack('${menu['nama']} masuk keranjang');
  }

  void _ubahQty(int index, int delta) {
    setState(() {
      final qtyBaru = (_keranjang[index]['qty'] as int) + delta;
      if (qtyBaru <= 0) {
        _keranjang.removeAt(index);
      } else {
        _keranjang[index]['qty'] = qtyBaru;
      }
    });
  }

  Future<void> _konfirmasiHapusItem(int index) async {
    final namaItem = _keranjang[index]['nama'].toString();
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Hapus "$namaItem" dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      setState(() {
        _keranjang.removeAt(index);
      });
      _showSnack('"$namaItem" dihapus dari keranjang', warna: Colors.red);
    }
  }

  Future<void> _prosesPembayaran() async {
    if (_keranjang.isEmpty) return;

    final subtotal = _subtotalKeranjang;
    final diskon = _potonganDiskon;
    final total = _totalAkhir;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ringkasan Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah item: $_jumlahItem'),
            Text('Subtotal: ${formatRupiah(subtotal)}'),
            if (diskon > 0) Text('Diskon 10%: -${formatRupiah(diskon)}'),
            const Divider(),
            Text(
              'Total Bayar: ${formatRupiah(total)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Bayar'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      setState(() {
        _keranjang.clear();
      });
      _showSnack('Pembayaran berhasil! Terima kasih');
    }
  }

  void _tampilkanTentangAplikasi() {
    showDialog<void>(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Tentang Aplikasi'),
        content: Text(
          'Kantin Digital Kampus merupakan aplikasi pemesanan makanan, '
          'minuman, dan camilan berbasis data lokal.',
        ),
      ),
    );
  }

  Widget _buildTabMenu() {
    final kategoriAktif = kategoriMenu[_selectedCategoryIndex];
    final menuTersaring = daftarMenuKantin.where((item) {
      final cocokKategori = item['kategori'] == kategoriAktif;
      final cocokCari =
          _searchQuery.trim().isEmpty ||
          item['nama'].toString().toLowerCase().contains(
            _searchQuery.trim().toLowerCase(),
          );
      return cocokKategori && cocokCari;
    }).toList();

    return DefaultTabController(
      length: kategoriMenu.length,
      initialIndex: _selectedCategoryIndex,
      child: Column(
        children: [
          Material(
            color: const Color(0xFF0D47A1),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.amberAccent,
              onTap: (index) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              tabs: const [
                Tab(text: 'Makanan'),
                Tab(text: 'Minuman'),
                Tab(text: 'Camilan'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari menu di $kategoriAktif...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: menuTersaring.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: menuTersaring.length,
                    itemBuilder: (context, index) {
                      final menu = menuTersaring[index];
                      return ItemMenuCard(
                        menu: menu,
                        onTambah: () => _tambahKeKeranjang(menu),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabKeranjang() {
    if (_keranjang.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 84, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Keranjang masih kosong',
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final subtotal = _subtotalKeranjang;
    final diskon = _potonganDiskon;
    final total = _totalAkhir;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              const Icon(Icons.shopping_cart, color: Color(0xFF0D47A1)),
              const SizedBox(width: 8),
              Text(
                'Keranjang ($_jumlahItem item)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            itemCount: _keranjang.length,
            itemBuilder: (context, index) {
              final item = _keranjang[index] as Map<String, dynamic>;
              return ItemKeranjangCard(
                item: item,
                onKurang: () => _ubahQty(index, -1),
                onTambah: () => _ubahQty(index, 1),
                onHapus: () => _konfirmasiHapusItem(index),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            children: [
              if (diskon > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text(formatRupiah(subtotal)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Diskon 10% (min. Rp 50.000)',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      '-${formatRupiah(diskon)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatRupiah(total),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _prosesPembayaran,
                  icon: const Icon(Icons.payments),
                  label: const Text('Pembayaran'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Digital - $_npmMahasiswa ($_namaMahasiswa)'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black87,
                    child: Text(
                      _inisialDariNama(_namaMahasiswa),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    _namaMahasiswa,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'NPM: $_npmMahasiswa  •  Kelas: $_kelasMahasiswa',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Menu Kantin'),
              onTap: () {
                setState(() => _selectedNavIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text('Keranjang ($_jumlahItem)'),
              onTap: () {
                setState(() => _selectedNavIndex = 1);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                Navigator.pop(context);
                _tampilkanTentangAplikasi();
              },
            ),
          ],
        ),
      ),
      body: _selectedNavIndex == 0 ? _buildTabMenu() : _buildTabKeranjang(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        selectedItemColor: const Color(0xFF0D47A1),
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _jumlahItem > 0,
              label: Text('$_jumlahItem'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
