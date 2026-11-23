const List<String> kategoriMenu = ['Makanan', 'Minuman', 'Camilan'];

const List daftarMenuKantin = [
  // Makanan
  {
    'id': 'm1',
    'nama': 'Nasi Ayam Geprek',
    'harga': 10000,
    'kategori': 'Makanan',
    'emoji': '🍗',
  },
  {
    'id': 'm2',
    'nama': 'Mie Ayam Bakso',
    'harga': 12000,
    'kategori': 'Makanan',
    'emoji': '🍜',
  },
  {
    'id': 'm3',
    'nama': 'Nasi Kuning',
    'harga': 15000,
    'kategori': 'Makanan',
    'emoji': '🍚',
  },
  {
    'id': 'm4',
    'nama': 'Lontong Sayur',
    'harga': 15000,
    'kategori': 'Makanan',
    'emoji': '🍲',
  },
  {
    'id': 'm5',
    'nama': 'Soto',
    'harga': 10000,
    'kategori': 'Makanan',
    'emoji': '🥘',
  },
  {
    'id': 'm6',
    'nama': 'Bubur',
    'harga': 8000,
    'kategori': 'Makanan',
    'emoji': '🥣',
  },
  // Minuman
  {
    'id': 'd1',
    'nama': 'Teh',
    'harga': 3000,
    'kategori': 'Minuman',
    'emoji': '🧋',
  },
  {
    'id': 'd2',
    'nama': 'Kopi',
    'harga': 5000,
    'kategori': 'Minuman',
    'emoji': '☕',
  },
  {
    'id': 'd3',
    'nama': 'Es Jeruk',
    'harga': 5000,
    'kategori': 'Minuman',
    'emoji': '🍊',
  },
  {
    'id': 'd4',
    'nama': 'Susu',
    'harga': 4000,
    'kategori': 'Minuman',
    'emoji': '🥛',
  },
  // Camilan
  {
    'id': 'c1',
    'nama': 'Kentang Goreng',
    'harga': 8000,
    'kategori': 'Camilan',
    'emoji': '🍟',
  },
  {
    'id': 'c2',
    'nama': 'Tahu Crispy',
    'harga': 6000,
    'kategori': 'Camilan',
    'emoji': '🧆',
  },
  {
    'id': 'c3',
    'nama': 'Pisang Coklat Keju',
    'harga': 12000,
    'kategori': 'Camilan',
    'emoji': '🍌',
  },
  {
    'id': 'c3',
    'nama': 'Roti Lapis',
    'harga': 10000,
    'kategori': 'Camilan',
    'emoji': '🥪',
  },
];

String formatRupiah(int angka) {
  final str = angka.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(str[i]);
  }
  return 'Rp ${buffer.toString()}';
}
