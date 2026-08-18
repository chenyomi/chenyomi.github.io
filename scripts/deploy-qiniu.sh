#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ENV_FILE="$ROOT/.env.qiniu"
QSHELL_BIN="${QSHELL_BIN:-}"
QSHELL_VERSION="${QSHELL_VERSION:-v2.19.12}"
SKIP_BUILD="${SKIP_BUILD:-0}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE"
  echo "Copy .env.qiniu.example to .env.qiniu and fill in AccessKey / SecretKey / bucket."
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${QINIU_ACCESS_KEY:?QINIU_ACCESS_KEY is required in .env.qiniu}"
: "${QINIU_SECRET_KEY:?QINIU_SECRET_KEY is required in .env.qiniu}"
: "${QINIU_BUCKET:?QINIU_BUCKET is required in .env.qiniu}"

QINIU_KEY_PREFIX="${QINIU_KEY_PREFIX:-}"
QINIU_CDN_DOMAIN="${QINIU_CDN_DOMAIN:-}"

ensure_qshell() {
  if [[ -n "$QSHELL_BIN" && -x "$QSHELL_BIN" ]]; then
    return
  fi

  if command -v qshell >/dev/null 2>&1; then
    QSHELL_BIN="$(command -v qshell)"
    return
  fi

  local os arch asset ext archive binary_name
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "$os" in
    darwin) os="darwin" ;;
    linux) os="linux" ;;
    *)
      echo "Unsupported OS: $os. Install qshell first: https://developer.qiniu.com/kodo/1302/qshell"
      exit 1
      ;;
  esac

  case "$arch" in
    arm64|aarch64) arch="arm64" ;;
    x86_64|amd64) arch="amd64" ;;
    *)
      echo "Unsupported architecture: $arch. Install qshell first."
      exit 1
      ;;
  esac

  mkdir -p "$ROOT/scripts/.bin"
  QSHELL_BIN="$ROOT/scripts/.bin/qshell"
  if [[ -x "$QSHELL_BIN" ]]; then
    return
  fi

  asset="qshell-${QSHELL_VERSION}-${os}-${arch}"
  archive="${asset}.tar.gz"
  binary_name="qshell-${os}-${arch}"
  local url="https://github.com/qiniu/qshell/releases/download/${QSHELL_VERSION}/${archive}"
  local tmp
  tmp="$(mktemp -d)"

  echo "Downloading qshell ${QSHELL_VERSION}..."
  curl -fsSL "$url" -o "$tmp/$archive"
  tar -xzf "$tmp/$archive" -C "$tmp"

  if [[ -f "$tmp/$binary_name" ]]; then
    mv "$tmp/$binary_name" "$QSHELL_BIN"
  elif [[ -f "$tmp/qshell" ]]; then
    mv "$tmp/qshell" "$QSHELL_BIN"
  else
    echo "Could not find qshell binary in the downloaded archive."
    ls -la "$tmp"
    exit 1
  fi

  chmod +x "$QSHELL_BIN"
  rm -rf "$tmp"
}

build_site() {
  if [[ "$SKIP_BUILD" == "1" ]]; then
    echo "SKIP_BUILD=1, using existing _site/"
    return
  fi

  echo "Building Jekyll site..."
  if command -v docker >/dev/null 2>&1; then
    docker compose run --rm jekyll jekyll build
  elif command -v bundle >/dev/null 2>&1; then
    bundle exec jekyll build
  else
    echo "Need Docker or Bundler to build the site."
    exit 1
  fi
}

upload_site() {
  if [[ ! -f "$ROOT/_site/index.html" ]]; then
    echo "Build output missing: _site/index.html"
    exit 1
  fi

  mkdir -p "$ROOT/scripts"

  echo "Configuring qshell account for this project..."
  (
    cd "$ROOT/scripts"
    "$QSHELL_BIN" -L account -- "$QINIU_ACCESS_KEY" "$QINIU_SECRET_KEY" chenyomi-site >/dev/null
  )

  local args=(
    qupload2
    --src-dir="$ROOT/_site"
    --bucket="$QINIU_BUCKET"
    --overwrite
    --rescan-local
    --check-hash
    --thread-count=8
    --skip-suffixes=".DS_Store"
    --skip-fixed-strings="docker-compose.yml"
    --log-level=info
  )

  if [[ -n "$QINIU_KEY_PREFIX" ]]; then
    args+=(--key-prefix="$QINIU_KEY_PREFIX")
  fi

  echo "Uploading _site/ to Qiniu bucket: $QINIU_BUCKET"
  (
    cd "$ROOT/scripts"
    "$QSHELL_BIN" -L "${args[@]}"
  )
}

refresh_cdn() {
  if [[ -z "$QINIU_CDN_DOMAIN" ]]; then
    return
  fi

  local domain="${QINIU_CDN_DOMAIN%/}"
  local urls_file
  urls_file="$(mktemp)"
  {
    echo "$domain/"
    echo "$domain/index.html"
    echo "$domain/about/"
    echo "$domain/projects/"
  } > "$urls_file"

  echo "Refreshing CDN: $domain"
  (
    cd "$ROOT/scripts"
    "$QSHELL_BIN" -L cdnrefresh "$urls_file"
  ) || {
    echo "CDN refresh failed. Files are uploaded; you can refresh manually in the Qiniu console."
  }
  rm -f "$urls_file"
}

ensure_qshell
build_site
upload_site
refresh_cdn

echo
echo "Done."
echo "Uploaded: $ROOT/_site  ->  bucket:$QINIU_BUCKET${QINIU_KEY_PREFIX:+/$QINIU_KEY_PREFIX}"
if [[ -n "$QINIU_CDN_DOMAIN" ]]; then
  echo "Site: $QINIU_CDN_DOMAIN"
fi
