# claude-imagegen-skill

Skill agent untuk membuat ilustrasi dengan imagegen GPT lewat Codex CLI. Codex memakai login langganan ChatGPT, jadi tidak perlu `OPENAI_API_KEY`. Skill ini paling berguna dari Claude Code, karena Claude tidak punya alat pembuat gambar sendiri.

Alurnya empat langkah: agent menulis brief, `codex exec` membuat gambar dengan rujukan gaya, agent memeriksa hasilnya secara visual, lalu PNG asli, WebP opsional, dan arsip brief disimpan.

## Prasyarat

- [Codex CLI](https://github.com/openai/codex) terpasang dan login dengan akun ChatGPT (`codex login status`).
- Fitur `image_generation` aktif (`codex features list | grep image_generation`).
- Opsional: `cwebp` untuk keluaran WebP.

## Pasang

```bash
git clone https://github.com/wiraperdana/claude-imagegen-skill.git
cd claude-imagegen-skill
./install.sh
```

`install.sh` membuat symlink `~/.claude/skills/claude-imagegen` dan `~/.agents/skills/claude-imagegen`. Perubahan di repo langsung terbaca kedua harness. Untuk melepas, hapus kedua symlink itu.

Nama skillnya `claude-imagegen`, mengikuti nama repo. Nama `imagegen` saja tidak dipakai karena Codex sudah punya skill sistem bernama `imagegen`.

## Pakai

Di Claude Code: `/claude-imagegen <apa yang ingin digambar>`.

Langsung dari terminal:

```bash
skills/claude-imagegen/scripts/gen.sh --out art/pushpull.png --brief brief.txt --ref style.png --webp 1400
skills/claude-imagegen/scripts/gen.sh --out art/test.png --brief brief.txt --dry-run   # lihat perintah tanpa memakai kuota
```

Template brief dan contoh yang sudah teruji ada di `skills/claude-imagegen/references/brief-template.md`.

## Perlu diketahui

- Brief dan gambar rujukan terkirim ke OpenAI. Jangan lampirkan materi rahasia tanpa izin.
- Setiap gambar memakai kuota langganan ChatGPT, sekitar 18 ribu token per gambar pada uji pertama.
- Versi model gambar ditentukan Codex dan tidak bisa dipilih lewat parameter.
- Teks panjang di dalam gambar sering salah eja. Selalu periksa hasilnya sebelum dipakai.

## Lisensi

MIT, lihat [LICENSE](LICENSE).
