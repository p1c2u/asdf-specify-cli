#!/usr/bin/env bash

set -euo pipefail

TOOL_NAME="specify-cli"
TOOL_TEST="specify --help"

fail() {
  echo -e "asdf-${TOOL_NAME}: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "https://github.com/github/spec-kit.git" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # Specify CLI is a Python package, we'll download from GitHub
  url="https://github.com/github/spec-kit/archive/refs/tags/v${version}.tar.gz"

  echo "* Downloading ${TOOL_NAME} release ${version}..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-${TOOL_NAME} supports release installs only"
  fi

  (
    mkdir -p "$install_path/bin"
    
    # Extract the downloaded archive
    tar -xzf "$ASDF_DOWNLOAD_PATH/specify-cli-${version}.tar.gz" -C "$ASDF_DOWNLOAD_PATH" || fail "Could not extract archive"
    
    # Find the extracted directory
    local extracted_dir
    extracted_dir=$(find "$ASDF_DOWNLOAD_PATH" -maxdepth 1 -type d -name "spec-kit-*" | head -n1)
    
    if [ -z "$extracted_dir" ]; then
      fail "Could not find extracted directory"
    fi

    # Check if Python is available
    if ! command -v python3 &> /dev/null; then
      fail "python3 is required but not found in PATH"
    fi

    # Create a virtual environment in the install path
    python3 -m venv "$install_path/venv" || fail "Could not create virtual environment"
    
    # Upgrade pip, setuptools, and wheel (optional - continue on failure)
    "$install_path/venv/bin/pip" install --upgrade --timeout 300 pip setuptools wheel 2>/dev/null || echo "Warning: Could not upgrade pip, continuing with existing version"
    "$install_path/venv/bin/pip" install --timeout 300 "$extracted_dir" || fail "Could not install ${TOOL_NAME}"
    
    # Create a wrapper script
    cat > "$install_path/bin/specify" << EOF
#!/usr/bin/env bash
exec "$install_path/venv/bin/specify" "\$@"
EOF
    chmod +x "$install_path/bin/specify"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "${TOOL_NAME} ${version} installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing ${TOOL_NAME} ${version}."
  )
}
