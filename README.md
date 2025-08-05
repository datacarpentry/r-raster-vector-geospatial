[![DOI](https://zenodo.org/badge/44772343.svg)](https://zenodo.org/badge/latestdoi/44772343)
[![01 Build and Deploy Site](https://github.com/datacarpentry/r-raster-vector-geospatial/actions/workflows/sandpaper-main.yaml/badge.svg)](https://github.com/datacarpentry/r-raster-vector-geospatial/actions/workflows/sandpaper-main.yaml)
[![Create a Slack Account with us](https://img.shields.io/badge/Create_Slack_Account-The_Carpentries-071159.svg)](https://swc-slack-invite.herokuapp.com/)
[![Slack Status](https://img.shields.io/badge/Slack_Channel-dc--geospatial-E01563.svg)](https://swcarpentry.slack.com/messages/C9ME7G5RD)

# R for Raster and Vector Data

## Contributing to lesson development

- The lesson files to be edited are in the `_episodes` folder. This repository uses the `main` branch for development.
- You can visualize the changes locally with the [sandpaper](https://github.com/carpentries/sandpaper) R package by executing either the `sandpaper::serve()` or `sandpaper::build_lesson()` commands. In the former case, the site will be rendered at [http://localhost:4321](http://localhost:4321)
- Each time you push a change to GitHub, Github Actions rebuilds the lesson, and when it's successful (look for the green badge at the top of the README file), it publishes the result at [https://www.datacarpentry.org/r-raster-vector-geospatial/](https://www.datacarpentry.org/r-raster-vector-geospatial/)
- Note: any manual commit to `gh-pages` will be erased and lost during the automated build and deploy cycle operated by Github Actions.

### Lesson Maintainers:

- [Jemma Stachelek][stachelek_jemma]
- [Ivo Arrey][arreyves]
- [Jon Jablonski][jonjab]
- Drake Asberry

[stachelek_jemma]: https://carpentries.org/instructors/#jsta
[arreyves]: https://carpentries.org/instructors/#arreyves
[jonjab]: https://carpentries.org/instructors/#jonjab
