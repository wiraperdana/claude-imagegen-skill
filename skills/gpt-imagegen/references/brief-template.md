# Template brief

Tulis brief dalam bahasa Inggris. Imagegen lebih patuh pada instruksi Inggris, termasuk untuk adegan berlatar Indonesia. Instruksi simpan file ditambahkan otomatis oleh `scripts/gen.sh`, jadi brief cukup berisi isi gambar.

```text
Style: <gaya visual. Bila ada rujukan: "match the attached reference image closely (...)">. <rasio, misalnya Landscape 3:2>.

Scene: <komposisi utama dalam satu kalimat>.
<bagian 1: siapa, melakukan apa, di mana>
<bagian 2: ...>

Text allowed in the image, exactly: '<label 1>', '<label 2>'. No other text, no watermark, no logos.
<batasan lain: karakter, pakaian, hal yang harus dihindari>
```

## Aturan menulis brief

1. **Satu gambar, satu gagasan.** Bila butuh dua konsep, pakai komposisi terbelah dengan pembatas yang jelas.
2. **Teks sesedikit mungkin.** Maksimal 4 sampai 6 label pendek. Tulis tiap label persis dalam tanda kutip tunggal.
3. **Sebut rasio.** 3:2 landscape untuk ilustrasi materi, 16:9 untuk slide, 1:1 untuk kartu.
4. **Rujukan gaya.** Lampirkan satu gambar yang sudah disetujui, supaya seri gambar tetap konsisten.
5. **Larangan eksplisit.** Teks lain, watermark, logo merek, dan wajah tokoh nyata.

## Contoh yang sudah teruji

Hasilnya 1536x1024, keempat label tepat, dan gayanya konsisten dengan rujukan.

```text
Style: match the attached reference image closely (warm semi-realistic digital illustration, Indonesian bakery setting, bright natural light, same character rendering style). Landscape 3:2.

Scene: one picture split into two halves by a thin vertical divider.
Left half, label 'PUSH': early morning before the shop opens. A baker fills shelves with many identical loaves made in advance. A small chalkboard on the wall reads 'Forecast: 100'.
Right half, label 'PULL': a customer at the counter shows an order on a phone. A baker decorates one birthday cake made only for that order. A small paper ticket on the counter reads 'Order #27'.

Text allowed in the image, exactly: 'PUSH', 'PULL', 'Forecast: 100', 'Order #27'. No other text, no watermark, no logos. Indonesian characters, modest clothing.
```

## Brief revisi

Untuk perbaikan kecil, lampirkan hasil sebelumnya sebagai `--ref`, lalu tulis instruksi sempit:

```text
Edit the attached image. Keep the composition, characters, colors, and all other text unchanged.
Change only: <perubahan tunggal, misalnya the label 'Fore cast' must read 'Forecast: 100'>.
```
