#!/bin/bash
musicFolder=~/music2
if [[ $# == 0 ]]; then
    echo "Need at least one folder with albums as input"
    exit 1
fi
albumArtistsBefore=$(beet ls -af '$albumartist\t$album' added-)
echo "$albumArtistsBefore"
for albumFolder in "$@"; do
    echo "Importing $albumFolder"
    beet import "$(realpath "$albumFolder")"
done
albumArtistsAfter=$(beet ls -af '$albumartist\t$album' added-)
numAddedAlbums=$(diff <(echo -E "$albumArtistsBefore") <(echo -E "$albumArtistsAfter") | grep "^>" | wc -l)
artists=$(beet ls -af '$albumartist' added- | head -n $numAddedAlbums)
albums=$(beet ls -af '$album' added- | head -n $numAddedAlbums)
for i in $(seq 1 $numAddedAlbums); do
    artist=$(echo -E "$artists" | head -n $i | tail -n 1)
    album=$(echo -E "$albums" | head -n $i | tail -n 1)
    echo "Adding: \"$artist\", \"$album\""
    echo "\"$artist\", \"$album\"" >> "$musicFolder/quarantine"
done
