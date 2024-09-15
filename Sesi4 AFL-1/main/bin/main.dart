import 'dart:io'; // Mengimpor pustaka untuk berinteraksi dengan input/output di konsol
import 'dart:async'; // Mengimpor pustaka untuk menangani operasi asynchronous
import 'dart:convert'; // Mengimpor pustaka untuk encoding dan decoding JSON
import 'package:http/http.dart' as http; // Mengimpor pustaka HTTP untuk melakukan request ke API

// Fungsi untuk keluar dari aplikasi
void keluarAplikasi() {
  print("\n--Terima kasih telah menjelajah bersama kami. Semoga harimu menyenangkan!--");
  exit(0); // Menghentikan eksekusi program
}

// Fungsi asynchronous untuk mengambil data lagu dari API
Future<void> ambilLagu(String pencarian, String jenisPencarian) async {
  try {
    // Menentukan jenis entitas yang dicari berdasarkan input pengguna
    var entity = jenisPencarian == '1' ? 'song' : 'musicTrack';
    var url = "https://itunes.apple.com/search?term=${Uri.encodeComponent(pencarian)}&entity=$entity";
    
    // Melakukan request HTTP ke API
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika response berhasil (status code 200), decode data JSON
      var data = json.decode(response.body);
      var hasil = data["results"];
      print("Ditemukan ${hasil.length} lagu."); // Menampilkan jumlah lagu yang ditemukan

      if (hasil.isNotEmpty) {
        // Menampilkan daftar lagu
        for (int i = 0; i < hasil.length; i++) {
          print("${i + 1}. ${hasil[i]["trackName"]} oleh ${hasil[i]["artistName"]}");
        }

        while (true) {
          // Menunggu input pengguna untuk memilih lagu atau kembali
          print("Pilih nomor lagu untuk informasi lebih lanjut atau ketik 'BACK' untuk kembali.");
          var pilihan = stdin.readLineSync();

          if (pilihan?.toUpperCase() == 'BACK') {
            break; // Kembali ke menu utama jika pengguna mengetik 'BACK'
          }

          var nomorLagu = int.tryParse(pilihan ?? '');
          if (nomorLagu != null && nomorLagu > 0 && nomorLagu <= hasil.length) {
            // Menampilkan detail lagu yang dipilih
            var lagu = hasil[nomorLagu - 1];
            print("Lagu: ${lagu["trackName"]}");
            print("Artis: ${lagu["artistName"]}");
            print("Album: ${lagu["collectionName"]}");
            print("Genre: ${lagu["primaryGenreName"]}");
            print("Durasi: ${lagu["trackTimeMillis"] / 1000} detik");
          } else {
            print("Nomor pilihan tidak valid. Silakan coba lagi.");
          }
        }
      } else {
        print("Tidak ada lagu yang ditemukan."); // Menampilkan pesan jika tidak ada lagu yang ditemukan
      }
    } else {
      print("Gagal mengambil data."); // Menampilkan pesan jika request ke API gagal
    }
  } catch (e) {
    print("Terjadi kesalahan: $e"); // Menampilkan pesan jika terjadi kesalahan
  }
}

void main() async {
  while (true) {
    // Menu utama aplikasi
    print("Selamat datang di Aplikasi Penjelajahan Musik!");
    print("Pilih jenis pencarian:");
    print("1. Berdasarkan lagu");
    print("2. Berdasarkan artis");
    print("Ketik 'EXIT' untuk keluar kapan saja.");

    var pilihan = stdin.readLineSync();
    if (pilihan?.toUpperCase() == "EXIT") {
      keluarAplikasi(); // Keluar dari aplikasi jika pengguna mengetik 'EXIT'
    } else if (pilihan == '1' || pilihan == '2') {
      print("Masukkan pencarian:");
      var pencarian = stdin.readLineSync();
      if (pencarian != null && pencarian.isNotEmpty) {
        await ambilLagu(pencarian, pilihan!); // Mengambil data lagu berdasarkan input pengguna
      } else {
        print("Input tidak valid. Silakan coba lagi."); // Menampilkan pesan jika input pencarian kosong
      }
    } else {
      print("Pilihan tidak valid. Silakan pilih 1 atau 2.");
      continue; // Mengulang loop jika input tidak valid
    }

    // Menanyakan apakah pengguna ingin mengulang
    while (true) {
      print("Apakah Anda ingin mengulang? (Y/N)");
      var ulang = stdin.readLineSync();
      if (ulang?.toUpperCase() == 'N') {
        keluarAplikasi(); // Keluar dari aplikasi jika pengguna mengetik 'N'
      } else if (ulang?.toUpperCase() == 'Y') {
        break; // Kembali ke menu utama jika pengguna mengetik 'Y'
      } else {
        print("Pilihan tidak valid. Silakan ketik 'Y' untuk mengulang atau 'N' untuk keluar.");
      }
    }
  }
}
