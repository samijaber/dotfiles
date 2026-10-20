#!/bin/bash
# Builds HelixOpener.app and makes it the default handler for code/text files.
set -euo pipefail

BUNDLE_ID="com.samijaber.helix-opener"
APP="$HOME/Applications/HelixOpener.app"
TYPE_PREFIX="$BUNDLE_ID.type"

# Extensions macOS has no UTI for; we declare one per extension.
EXTENSIONS=(
  astro bash_profile bashrc bat cfg cjs clj cljs cls cmake cmd coffee conf config
  containerfile cs csx cts dart dockerfile dtd editorconfig env erb erl ex eyaml eyml
  fish fs fsi fsx gemspec gitattributes gitconfig gitignore go gql gradle graphql
  groovy handlebars hbs hcl heex ini ipynb jade json5 jsonc jsx kt kts less lock
  lua makefile mdx ml mli nix prisma profile properties proto ps1 psd1 psm1 pug pyi
  rs rst sass scala scss sql svelte tex tf tfvars toml tsx vb vue wgsl xaml zig
  zshenv zshrc
)

# Existing system UTIs. public.mpeg-2-transport-stream is how macOS classifies .ts.
SYSTEM_UTIS=(
  public.plain-text public.source-code public.script public.shell-script
  public.bash-script public.zsh-script public.c-source public.c-header
  public.c-plus-plus-source public.c-plus-plus-header public.objective-c-source
  public.objective-c-plus-plus-source public.swift-source public.make-source
  public.python-script public.ruby-script public.perl-script public.php-script
  com.sun.java-source com.netscape.javascript-source com.apple.rez-source
  public.css public.json public.xml public.yaml public.patch-file
  public.comma-separated-values-text com.apple.log
  net.daringfireball.markdown
  public.mpeg-2-transport-stream
)

cd "$(dirname "$0")"

rm -rf "$APP"
osacompile -o "$APP" HelixOpener.applescript

PLIST="$APP/Contents/Info.plist"
pb() { /usr/libexec/PlistBuddy -c "$1" "$PLIST"; }

pb "Add :CFBundleIdentifier string $BUNDLE_ID" 2>/dev/null || pb "Set :CFBundleIdentifier $BUNDLE_ID"
pb "Delete :CFBundleDocumentTypes" 2>/dev/null || true
pb "Delete :UTImportedTypeDeclarations" 2>/dev/null || true
pb "Add :CFBundleDocumentTypes array"
pb "Add :CFBundleDocumentTypes:0 dict"
pb "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Editor"
pb "Add :CFBundleDocumentTypes:0:LSHandlerRank string Default"
pb "Add :CFBundleDocumentTypes:0:CFBundleTypeExtensions array"
pb "Add :CFBundleDocumentTypes:0:LSItemContentTypes array"
pb "Add :UTImportedTypeDeclarations array"

i=0
uti_for() { echo "$TYPE_PREFIX.${1//_/-}"; }

for ext in "${EXTENSIONS[@]}"; do
  uti=$(uti_for "$ext")
  pb "Add :CFBundleDocumentTypes:0:CFBundleTypeExtensions: string $ext"
  pb "Add :CFBundleDocumentTypes:0:LSItemContentTypes: string $uti"
  pb "Add :UTImportedTypeDeclarations:$i dict"
  pb "Add :UTImportedTypeDeclarations:$i:UTTypeIdentifier string $uti"
  pb "Add :UTImportedTypeDeclarations:$i:UTTypeConformsTo array"
  pb "Add :UTImportedTypeDeclarations:$i:UTTypeConformsTo: string public.plain-text"
  pb "Add :UTImportedTypeDeclarations:$i:UTTypeTagSpecification dict"
  pb "Add :UTImportedTypeDeclarations:$i:UTTypeTagSpecification:public.filename-extension array"
  pb "Add :UTImportedTypeDeclarations:$i:UTTypeTagSpecification:public.filename-extension: string $ext"
  i=$((i + 1))
done
for uti in "${SYSTEM_UTIS[@]}"; do
  pb "Add :CFBundleDocumentTypes:0:LSItemContentTypes: string $uti"
done

codesign --force --deep --sign - "$APP" 2>/dev/null
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"

failed=()
for ext in "${EXTENSIONS[@]}"; do
  duti -s "$BUNDLE_ID" "$(uti_for "$ext")" all || failed+=("$ext")
done
for uti in "${SYSTEM_UTIS[@]}"; do
  duti -s "$BUNDLE_ID" "$uti" all || failed+=("$uti")
done

echo "HelixOpener installed for ${#EXTENSIONS[@]} extensions and ${#SYSTEM_UTIS[@]} system types."
if ((${#failed[@]})); then
  echo "Failed: ${failed[*]}"
  exit 1
fi
