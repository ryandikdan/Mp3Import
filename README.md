# Mp3Import
I was annoyed with importing mp3 files that have metadata inside of them manually, and had difficulty with other existing tools (beets), so I made a manual version which uses the metadata using `id3v2` (which must be installed before using this.) I was so surprised by how well it worked I thought I'd share it.
## Usage
Just run this script with a folder containing mp3 files like: `./manually_import_mp3.sh /folder/withmp3s/`. You'll have to change the `/desired/music/directory` on line 49 to your desired library directory.
It's really just a commandline tool for linux.
## How it works
In brief, it uses `id3v2`, and other basic command line tools (`grep`, `awk`, `tr`, `sed`) and tries to pull the album artist, then makes that folder if it doesn't exist. If there isn't an album artist it defaults to the artist (although this causes issues when there's featured artists, so album artist has been working better). Then it makes an album folder in the artist/artist folder using the album name and the year that album came out. Then it names the files by the track number and the track title. I think it'll work well with spotdl.
