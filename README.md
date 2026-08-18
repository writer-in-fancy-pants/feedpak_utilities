# Fee[dB]ack Utilities
A Docker wrapper to help run old / platform specific feedpak scripts on any platform. A work in progress. This project is not associated with official Fee[dB]ack platform, nor the scripts it wraps. Rather, it is a general utility wrapper that outputs .feedpak

## Currently supported
### psarc2feedpak : https://github.com/carelesshangman/psarc2feedpak
How to use
```
git clone https://github.com/writer-in-fancy-pants/feedpak_utilities.git
cd feedpak_utilities

docker compose run --rm psarc2feedpak
```

Directory structure
```
feedpak_utilities/
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
├── input/
│   ├── song1.psarc
│   ├── song2.psarc
│   └── subdirectory/
│       └── song3.psarc
└── output/
```

To start, either make the directory structure as shown above, and copy files to be converted to `./input`
Otherwise, edit `docker-compose.yml` and replace `./input` with your <source-dir> as shown: `<source-dir>:/input:ro`


