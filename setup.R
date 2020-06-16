## file structure

if (! file.exists("data/raster") | ! file.exists("data/vector")) {
    dest <- tempfile()
    download.file("https://ndownloader.figshare.com/files/23104040", dest,
                  mode = "wb")
    unzip(dest, exdir = "data")
}
