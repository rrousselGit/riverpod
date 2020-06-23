A Flutter app that displays the list of comics from https://developer.marvel.com/

**Note**: This example is outdated and still work in progress. This is not
(yet) representation of how to use [Riverpod] 

The process is split into three objects:

- `Configuration`, which stores the API keys of a marvel account.
  This object is loaded asynchronously by reading a JSON file.
- `Repository`, a utility that depends on `Configuration` to
  connect to https://developer.marvel.com/ and request the comics.
- `Model`, which uses a `Repository` to requests marvel comics and handle the pagination.

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

![marvel_account](https://github.com/rrousselGit/river_pod/blob/master/packages/riverpod/example/resources/marvel_portal.png)

[riverpod]: https://github.com/rrousselGit/river_pod