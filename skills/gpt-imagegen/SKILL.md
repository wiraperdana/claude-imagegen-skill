---
name: gpt-imagegen
description: Buat atau sunting ilustrasi raster dengan imagegen GPT lewat Codex CLI yang login memakai langganan ChatGPT, tanpa API key. Pakai saat pengguna meminta gambar, ilustrasi, atau infografis bergambar dibuat dengan "imagegen GPT", "gambar dari GPT", "Codex imagegen", atau "/gpt-imagegen", terutama dari Claude Code. Skill menulis brief, menjalankan codex exec dengan gambar rujukan gaya, memeriksa hasil secara visual, lalu menyimpan PNG asli, WebP opsional, dan arsip brief. Jangan dipakai untuk diagram yang lebih tepat dibuat sebagai SVG, HTML, atau kode.
---

# gpt-imagegen

Skill ini menjembatani agent ke alat `image_gen` bawaan Codex. Alat itu memakai login ChatGPT pengguna, jadi tidak perlu `OPENAI_API_KEY`.

Analogi sederhananya begini. Agent bertindak sebagai art director. Ia menulis brief, mengirimnya ke ilustrator (Codex), lalu memeriksa hasilnya sebelum dipakai. Ilustrator bekerja cepat, tetapi kadang salah mengeja label atau membalik arah panah. Karena itu pemeriksaan visual adalah langkah wajib, bukan pelengkap.

## Kapan dipakai

- Pengguna meminta ilustrasi, adegan cerita, atau gambar pendukung materi yang dibuat dengan imagegen GPT.
- Pengguna ingin gaya gambar konsisten dengan gambar yang sudah ada.

Untuk diagram dengan banyak label presisi, tawarkan dulu SVG atau HTML. Imagegen paling andal untuk adegan, dan paling rawan pada teks panjang.

Bila agent yang berjalan **adalah Codex sendiri**, pakai alat `image_gen` bawaannya langsung. Jangan memanggil `codex exec` dari dalam Codex.

## Prasyarat

1. `codex` ada di PATH dan sudah login dengan akun ChatGPT. Periksa dengan `codex login status`.
2. Fitur `image_generation` aktif. Periksa dengan `codex features list | grep image_generation`.
3. Opsional: `cwebp` untuk WebP, dan `sips` (macOS) atau Python Pillow untuk membaca ukuran gambar.

Bila prasyarat tidak terpenuhi, berhenti dan sebutkan yang kurang. Jangan beralih diam-diam ke API berbayar.

## Sebelum menjalankan, sampaikan dua hal ke pengguna

- Brief dan gambar rujukan terkirim ke OpenAI. Jangan melampirkan gambar rahasia, data pribadi, atau materi klien tanpa izin eksplisit.
- Setiap gambar memakai kuota langganan ChatGPT. Satu gambar uji memakai sekitar 18 ribu token, dan waktunya sekitar 2 menit.

Cukup sampaikan sekali per sesi, kecuali isi rujukannya berubah jenis.

## Prosedur

1. **Kumpulkan kebutuhan.** Tanyakan hanya yang belum jelas: tujuan gambar, rasio (default 3:2 landscape), teks yang wajib muncul, gambar rujukan gaya, dan lokasi simpan.
2. **Tulis brief** dalam bahasa Inggris memakai `references/brief-template.md`. Sebutkan teks yang diizinkan **persis**, lalu larang teks lain, watermark, dan logo.
3. **Jalankan skrip:**
   ```bash
   scripts/gen.sh --out <path/nama.png> --brief <brief.txt> [--ref <gambar.png>]... [--webp 1400]
   ```
   Skrip menambahkan instruksi simpan ke brief, mengirim brief lewat stdin, dan menyalin hasilnya. Brief harus lewat stdin karena opsi `-i` milik Codex menelan argumen posisi sesudahnya. Pakai `--dry-run` untuk melihat perintahnya tanpa memakai kuota.
4. **Periksa hasil secara visual.** Buka PNG-nya, lalu cek daftar di `references/qa-checklist.md`: ejaan setiap label, arah panah, tidak ada teks liar, rasio, dan kecocokan gaya.
5. **Revisi bila perlu**, paling banyak dua putaran. Pilih salah satu cara:
   - sunting brief lalu jalankan ulang, atau
   - lampirkan hasil sebelumnya sebagai `--ref` dengan instruksi edit yang sempit, misalnya "Keep everything, change only the label X to Y."
6. **Serahkan.** Laporkan path PNG, path WebP bila ada, ukuran piksel, dan hasil pemeriksaan visual. Sebutkan juga kekurangan yang masih ada.

## Keluaran

- `<nama>.png`: gambar asli dari Codex.
- `<nama>.brief.txt`: brief yang dipakai, supaya gambar bisa dibuat ulang atau direvisi.
- `<nama>.webp`: bila `--webp` diberikan, lebar sesuai angka dan rasio tetap.

Codex juga menyimpan salinan asli di `~/.codex/generated_images/`.

## Batasan yang perlu jujur disampaikan

- Versi model gambar tidak bisa dipilih lewat parameter. Codex menentukannya sendiri.
- Hasil tidak deterministik. Brief yang sama bisa menghasilkan gambar berbeda.
- Teks panjang di dalam gambar sering salah eja. Batasi teks ke beberapa label pendek.
