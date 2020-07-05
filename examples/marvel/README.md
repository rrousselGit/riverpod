A Flutter app that displays the list of comics from https://developer.marvel.com/

# Goal of this example

This example demonstrates how to:

- perform HTTP requests
- handle pagination
- cancel HTTP requests if the UI stops listening to the response before completion
- implement a search-bar that has its own independent state.
- support deep-linking to an item
- optimize widget rebuilds (only what needs to update does update).

![search](https://github.com/rrousselGit/river_pod/blob/master/examples/marvel/resources/search.png)

![home](https://github.com/rrousselGit/river_pod/blob/master/examples/marvel/resources/home.png)


# Installation

To run this example, you will need to create a `configuration.json` placed in the `assets` folder:

```
example/
  pubspec.yaml
  README.md << This readme
  assets/
    configuration.json  << Where to place the file
  lib/
```

The content of this file looks like this:

```json
{
  "public_key": "1234",
  "private_key": "5678"
}
```

Where `public_key` and `private_key` are obtained from https://developer.marvel.com/account

![marvel_account](https://github.com/rrousselGit/river_pod/blob/master/examples/marvel/resources/marvel_portal.png)

[riverpod]: https://github.com/rrousselGit/river_pod
