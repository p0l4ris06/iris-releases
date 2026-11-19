#!/bin/sh
# Verify an IRIS release: the signature on SHA256SUMS, then every download against SHA256SUMS.
# Usage: verify_release.sh [DIR] [PUBLIC_KEY_FILE]
#   DIR  the folder holding your downloads plus SHA256SUMS and SHA256SUMS.minisig (default: current folder)
#   PUBLIC_KEY_FILE  default: iris-release.pub next to this script (a copy is also in the repository)
# Needs: minisign (https://jedisct1.github.io/minisign/) and sha256sum (or shasum on macOS).
# Exit status 0 only if the signature is valid AND at least one download was found AND every one found matches.
set -eu

dir="${1:-.}"
here="$(cd "$(dirname "$0")" && pwd)"
key="${2:-$here/iris-release.pub}"

fail() { echo "VERIFY FAILED: $*" >&2; exit 1; }

[ -f "$key" ] || fail "public key file not found: $key"
if head -c 11 "$key" | grep -q '^PLACEHOLDER'; then
  fail "$key is still the placeholder: the release key has not been published yet. Do not trust this release."
fi
command -v minisign >/dev/null 2>&1 || fail "minisign is not installed (https://jedisct1.github.io/minisign/)"
[ -f "$dir/SHA256SUMS" ] || fail "$dir/SHA256SUMS not found"
[ -f "$dir/SHA256SUMS.minisig" ] || fail "$dir/SHA256SUMS.minisig not found: this release is not signed"

minisign -Vm "$dir/SHA256SUMS" -p "$key" -x "$dir/SHA256SUMS.minisig" || fail "the signature on SHA256SUMS is NOT valid"
echo "signature on SHA256SUMS: valid"

if command -v sha256sum >/dev/null 2>&1; then sum="sha256sum"; else sum="shasum -a 256"; fi
checked=0
bad=0
while IFS= read -r line; do
  [ -n "$line" ] || continue
  name="${line#*[ ]}"; name="${name#[ *]}"
  want="${line%% *}"
  if [ -f "$dir/$name" ]; then
    got="$($sum < "$dir/$name" | cut -d' ' -f1)"      # from stdin: a path with a backslash would make sha256sum prefix "\"
    if [ "$got" = "$want" ]; then echo "OK      $name"; checked=$((checked + 1))
    else echo "MISMATCH $name" >&2; bad=$((bad + 1)); fi
  fi
done < "$dir/SHA256SUMS"

[ "$bad" -eq 0 ] || fail "$bad file(s) do not match SHA256SUMS: do not install them"
[ "$checked" -gt 0 ] || fail "none of the files listed in SHA256SUMS is in $dir"
echo "verified: $checked file(s) match a correctly signed SHA256SUMS"
