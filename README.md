# Docker system for building PMIx and Open MPI+PMIx docker containers

1. Edit `build-me.sh` to specify the version information at the top of the script.

2. Run the build script to geneate the images

```
shell$ ./build-me.sh
...
=========================
Final Images
=========================
REPOSITORY          TAG                      IMAGE ID            CREATED             SIZE
ompi-play-box       ompi_v4.0.x-pmix_3.1.4   2a52e97078b1        1 second ago        1.07GB
ompi-play-box       pmix_3.1.4               561d89abeba8        9 minutes ago       618MB
```
