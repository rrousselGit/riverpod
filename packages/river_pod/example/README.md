A pure Dart script that fetches the list of comics from https://developer.marvel.com/

The process is split into two objects:

- `Configuration`, which stores the API keys of a marvel account.
  This object is loaded asynchronously by reading a JSON file.
- `Repository`, a utility that depends on `Configuration` to
  connect to https://developer.marvel.com/ and request the comics.

Both `Repository` and `Configuration` are created using [river_pod].

This showcases how to use [river_pod] without Flutter.\
It also shows how a provider can depend on another provider asynchronously loaded.

# Installation

To run this example, you will need to create a `configuration.json` file next to this README.md

```
example/
  pubspec.yaml
  README.md
  configuration.json  << Where to place that file
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

![marvel_account](https://github.com/rrousselGit/river_pod/blob/master/packages/river_pod/example/resources/marvel_portal.png)

[river_pod]: https://github.com/rrousselGit/river_pod