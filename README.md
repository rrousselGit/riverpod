Welcome to [provider_hooks]!

This project can be considered as an experimental [provider] v2, with a peer
dependency on [flutter_hooks].

It is very similar to [provider] in principle, but also has major differences
as an attempt to fix the common problem that [provider] faces.

See the [FAQ](#FAQ) if you have questions around what this means for [provider].

# Index

- [TL;DR](#tldr)
- [Motivation](#motivation)
- [FAQ](#faq)
  - [Why another project when provider already exists?](#why-another-project-when-provider-already-exists?)
  - [Is it safe to use in production?](#is-it-safe-to-use-in-production)
  - [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
  - [Will provider be deprecated/stop being supported?](#will-provider-be-deprecatedstop-being-supported)

# TL;DR

[provider_hooks] has goals similar to [provider]:

Simplifying the management of the different state/services of your app
and how Flutter's widget tree interacts with them while making sure
it is _testable_ and _scallable_.

# Motivation

# FAQ

## Why another project when [provider] already exists?

While [provider] is largely used and well accepted by the community,
it is not perfect either.

People regularly file issues or ask questions about some problems they face, such as:

- Why do I have a `ProviderNotFoundException`?
- How can I make that my state is automatically disposed of when not used anymore?
- How to make a provider that depends on other (potentially complex) providers?

These are legitimate problems, and I believe that something can be improved to fix
those.

The issue is, these problems are deeply related to how [provider] works, and
fixing those problems is likely impossible without drastic changes to the
mechanism of [provider].

This _could_ be merged inside [provider] directly, but would be betraying the
[provider] community to do so.\
See [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)

## Is it safe to use in production?

The project is still experimental, so use it at your own risk.

In theory, it should scale well to large projects and be easy to maintain.
It is also well tested and I would expect the API to be relatively stable.

But let's face it: The project is still experimental and I can't make
any promises.

## Will this get merged with [provider] at some point?

No. At least not until [flutter_hooks] gets merged into Flutter or becomes
more popular than [provider] itself, which are both unlikely.

While [provider] and this project have a lot in common, they do have some
major differences. Differences big enough that it would be a large breaking
change for users of [provider] to migrate [provider_hooks].

Considering this project relies on [flutter_hooks] to work, and that
[flutter_hooks] is far less popular than [provider] (at least for now),
then I think it would be mean to suddenly require provider users to use
[flutter_hooks].

## Will [provider] be deprecated/stop being supported?

Not in the short term, no.

This project is still experimental and unpopular. While it is, in a way,
a [provider] 2.0, its worth has yet to be proven.

Until it is certain that [provider_hooks] is a better way of doing things
and that the community likes it, I do not want to force people to migrate.

[provider]: https://github.com/rrousselGit/provider
[provider_hooks]: https://github.com/rrousselGit/provider_hooks
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
