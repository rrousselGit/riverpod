<p align="center">
<a href="https://github.com/rrousselGit/river_pod/actions"><img src="https://github.com/rrousselGit/river_pod/workflows/Build/badge.svg" alt="Build Status"></a>
<a href="https://codecov.io/gh/rrousselgit/river_pod"><img src="https://codecov.io/gh/rrousselgit/river_pod/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/rrousselgit/river_pod"><img src="https://img.shields.io/github/stars/rrousselgit/river_pod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>
<a href="https://www.buymeacoffee.com/remirousselet" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="25px"></a>

<p align="center">
<img src="https://github.com/rrousselGit/river_pod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

</p>

---

A migration tool for [riverpod](https://pub.dev/packages/riverpod).

To use:
Add to your `pubspec.yaml`:
```yaml
dev_dependencies:
  codemod_riverpod: ^0.0.2
```

Then on the command line
```
cd path/to/your/code
flutter pub get
flutter pub run codemod_riverpod
```

Make sure that your code has no analysis errors otherwise the codemod will have trouble running.

In particular:
- This will migrate the pubspec.yaml along with your code to the newest version of riverpod
- It will update to the latest riverpod syntax, even if you are using a path or git dependency of riverpod
  - You will then have to update the path / git dependency to the newest version of riverpod
  - It relies on a full analysis of your code, so make sure your code compiles before running