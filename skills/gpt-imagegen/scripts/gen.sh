#!/usr/bin/env bash
# Membuat satu gambar lewat alat image_gen bawaan Codex (login ChatGPT), lalu menyimpannya.
# Pakai: gen.sh --out <path.png> --brief <brief.txt> [--ref <gambar>]... [--webp <lebar>] [--dry-run]
set -euo pipefail

out=""; brief=""; webp=""; dry=0; refs=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) out=$2; shift 2 ;;
    --brief) brief=$2; shift 2 ;;
    --ref) refs+=("$2"); shift 2 ;;
    --webp) webp=$2; shift 2 ;;
    --dry-run) dry=1; shift ;;
    -h|--help) sed -n '2,3p' "$0"; exit 0 ;;
    *) echo "Argumen tidak dikenal: $1" >&2; exit 2 ;;
  esac
done
[[ -n "$out" && -n "$brief" ]] || { echo "Wajib: --out dan --brief" >&2; exit 2; }
[[ "$out" == *.png ]] || { echo "--out harus berakhiran .png" >&2; exit 2; }
[[ -f "$brief" ]] || { echo "Brief tidak ditemukan: $brief" >&2; exit 2; }
for r in "${refs[@]+"${refs[@]}"}"; do [[ -f "$r" ]] || { echo "Rujukan tidak ditemukan: $r" >&2; exit 2; }; done
command -v codex >/dev/null || { echo "codex tidak ada di PATH" >&2; exit 3; }
[[ -z "$webp" ]] || command -v cwebp >/dev/null || { echo "--webp butuh cwebp" >&2; exit 3; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
# Instruksi simpan ditambahkan di depan brief, supaya pengguna cukup menulis isi gambarnya.
{
  echo "Use your built-in image generation tool (not code) to create ONE image, then save the final image as ./output.png in the current working directory. Attached images, if any, are style or edit references."
  echo
  cat "$brief"
  echo
  echo "When done, reply with the saved file path and the image size."
} > "$work/prompt.txt"

args=(exec --skip-git-repo-check -s workspace-write -C "$work")
i=0
for r in "${refs[@]+"${refs[@]}"}"; do
  dest="$work/ref-$i-$(basename "$r")"; cp "$r" "$dest"; args+=(-i "$dest"); i=$((i + 1))
done

if [[ $dry -eq 1 ]]; then
  printf 'codex'; printf ' %q' "${args[@]}"; printf ' < %q\n' "$work/prompt.txt"
  echo "--- prompt ---"; cat "$work/prompt.txt"
  exit 0
fi

marker="$work/.start"; touch "$marker"
# Brief lewat stdin: opsi -i menelan argumen posisi sesudahnya.
codex "${args[@]}" < "$work/prompt.txt"

result="$work/output.png"
if [[ ! -f "$result" ]]; then
  # Cadangan: ambil gambar terbaru yang dibuat Codex selama proses ini.
  result=$(find "$HOME/.codex/generated_images" -type f -newer "$marker" -name '*.png' 2>/dev/null | xargs ls -t 2>/dev/null | head -1 || true)
fi
[[ -n "$result" && -f "$result" ]] || { echo "Gagal: Codex tidak menghasilkan gambar." >&2; exit 4; }

mkdir -p "$(dirname "$out")"
cp "$result" "$out"
cp "$brief" "${out%.png}.brief.txt"
if [[ -n "$webp" ]]; then
  cwebp -quiet -q 78 -resize "$webp" 0 "$out" -o "${out%.png}.webp"
fi

size=""
if command -v sips >/dev/null; then
  size=$(sips -g pixelWidth -g pixelHeight "$out" | awk '/pixelWidth/{w=$2}/pixelHeight/{h=$2}END{print w"x"h}')
elif command -v python3 >/dev/null; then
  size=$(python3 -c 'import sys;from PIL import Image;w,h=Image.open(sys.argv[1]).size;print(f"{w}x{h}")' "$out" 2>/dev/null || true)
fi
echo "Selesai: $out ${size:+($size)}"
[[ -z "$webp" ]] || echo "WebP: ${out%.png}.webp"
echo "Periksa label, arah panah, dan teks liar sebelum gambar dipakai."
