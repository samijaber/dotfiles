#!/bin/bash
# Builds HelixOpener.app and makes it the default handler for the extensions below.
set -euo pipefail

BUNDLE_ID="com.samijaber.helix-opener"
APP="$HOME/Applications/HelixOpener.app"
EXTENSIONS=(toml)

cd "$(dirname "$0")"

rm -rf "$APP"
osacompile -o "$APP" HelixOpener.applescript

PLIST="$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string $BUNDLE_ID" "$PLIST" 2>/dev/null ||
  /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID" "$PLIST"
/usr/libexec/PlistBuddy -c "Delete :CFBundleDocumentTypes" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0 dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Editor" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Default" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeExtensions array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" "$PLIST"
/usr/libexec/PlistBuddy -c "Delete :UTImportedTypeDeclarations" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations array" "$PLIST"
i=0
for ext in "${EXTENSIONS[@]}"; do
  # macOS has no built-in UTI for these, so declare one or duti can't bind a handler.
  uti="io.$ext"
  /usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeExtensions: string $ext" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes: string $uti" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i dict" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i:UTTypeIdentifier string $uti" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i:UTTypeConformsTo array" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i:UTTypeConformsTo: string public.plain-text" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i:UTTypeTagSpecification dict" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i:UTTypeTagSpecification:public.filename-extension array" "$PLIST"
  /usr/libexec/PlistBuddy -c "Add :UTImportedTypeDeclarations:$i:UTTypeTagSpecification:public.filename-extension: string $ext" "$PLIST"
  i=$((i + 1))
done

codesign --force --deep --sign - "$APP"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP"

for ext in "${EXTENSIONS[@]}"; do
  duti -s "$BUNDLE_ID" "io.$ext" all
done

echo "HelixOpener installed. Handlers:"
for ext in "${EXTENSIONS[@]}"; do
  echo "  .$ext -> $(duti -d "io.$ext")"
done
