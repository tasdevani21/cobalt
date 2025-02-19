#!/usr/bin/env bash

set -euo pipefail

cd "$BUILD_SOURCESDIRECTORY"

echo "Linting Go Files... If this fails, run 'go fmt ./...' to fix"

# This runs a go fmt on each file without using the 'go fmt ./...' syntax.
# This is advantageous because it avoids having to download all of the go
# dependencies that would have been triggered by using the './...' syntax.
FILES_WITH_FMT_ISSUES=$(find . -name "*.go" | grep -v '.terraform' | xargs gofmt -l | wc -l)

# convert to integer...
FILES_WITH_FMT_ISSUES=$(($FILES_WITH_FMT_ISSUES + 0))

exit $FILES_WITH_FMT_ISSUES
