#!/usr/bin/env sh

# update changelog
# ./script-update-changelog.js

# build
npm run build

# deploy
GIT_USER=magicdawn npm run publish-gh-pages