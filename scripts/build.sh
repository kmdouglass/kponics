#!/usr/bin/env sh

set -o errexit
set -o nounset

BUILD_DIR=build
SRC_DIR=src

PANDOC_FROM=org
PANDOC_FROM_FILE_EXT=.org
PANDOC_OPTIONS=--standalone
PANDOC_TO=html
PANDOC_TO_FILE_EXT=.html

render_lab_reports() {
    INPUT_FILE=$1

    # This builds the output filename by:
    # 1. replacing "src/path/to/file.xyz" with "$BUILD_DIR/path/to/file.xyz"
    # 2. replacing "$BUILD_DIR/path/to/file.xyz" with "$BUILD_DIR/path/to/file$PANDOC_TO_FILE_EXT"
    OUTPUT_FILE=$(echo "$BUILD_DIR/$(echo "$INPUT_FILE" | cut -d/ -f2-)" | sed "s/$PANDOC_FROM_FILE_EXT/$PANDOC_TO_FILE_EXT/")
    DIR_NAME=$(dirname "$OUTPUT_FILE")

    mkdir -p "$DIR_NAME"

    pandoc "$INPUT_FILE" --from="$PANDOC_FROM" --to="$PANDOC_TO" --output="$OUTPUT_FILE" "$PANDOC_OPTIONS"    
}

echo "Creating the build directory: $BUILD_DIR"
mkdir -p $BUILD_DIR

echo "Moving static files into the build directory"
(cd "$SRC_DIR" && find . -type f -name "*.html" -exec cp --parents -t "../$BUILD_DIR" {} +)

echo "Building lab reports"
find "$SRC_DIR" -type f -name "*$PANDOC_FROM_FILE_EXT" | while read -r line; do
    render_lab_reports "$line"
done

printf "\nDone!\n"
