## Contributing to Riverpod

So you want to contribute? Awesome! Contributions are welcomed.  
Before we get started on setting up the development environment, check out
our [Code of conduct](./CODE_OF_CONDUCT.md).  
You will also want to join our [Discord](https://discord.gg/Bbumvej) to chat.  
Feel free to ping @rrousselGit there for questions related to contributing.

With that out of the way, the way to contribute may vary depending on what you
want to contribute to.  
There are a few ways to contribute to the Riverpod ecosystem:

- Documentation work (adding new articles, fixing typos, translations).  
  This is the easiest and recommended way of contributing.
  There is generally a low barrier to entry with such contributions.

- Tooling work.
  You could work on side-tools for Riverpod, such as adding new lint rules
  or working on a migration CLI or devtool, etc...
  This is more technical, but code quality won't matter too much.

- Contributing to Riverpod itself.
  This is the hardest part. Adding new APIs will be generally very difficult,
  as we'll need to have an extensive discussion about that new API first.  
  If you want to contribute to Riverpod itself, it is recommended to work
  on bug fixes instead.

**It is highly encouraged to make an issue before creating your PR**  
This is especially crucial for larger work.  
You do not need to spend a lot of time making that issue. The important is:

- Mention that you want to contribute
- Explain a bit what you want to do.

Making an issue is important to discuss what needs to be done.  
You wouldn't want to spend tens of hours working on something, only to
have your PR rejected because we disagree on the direction taken.
An discussion may slow down the work initially, but it can save you from a lot
of frustration.

## Documentation work

Riverpod's documentation uses [Docusaurus](https://docusaurus.io/fr/docs).  
This framework is responsible for various features of the website. Check out
its documentation, as it may have the answer to your questions.

Documentation is written in "mdx", which is a combination of Markdown and JSX.  
If you are familiar with Markdown, this should be reasonably easy to pick up.
Feel free to look at existing pages to see how they work.

### Installing the website locally

The docs uses [node](https://nodejs.org/fr) and [yarn](https://yarnpkg.com/).  
You will need to install both and run:

```sh
yarn install
```

Then, you can start the documentation locally with:

```sh
yarn dev
```

Finally, head to `localhost:3000`

### Adding new language

Riverpod supports multiple languages.  
To add new languages, it is recommended to follow the [i18n](https://docusaurus.io/docs/i18n/introduction)
documentation of Docusaurus.

The English documentation is hosted in [`/website/docs`](https://github.com/rrousselGit/riverpod/tree/master/website/docs).  
Translations are hosted in [`/website/i18n`](https://github.com/rrousselGit/riverpod/tree/master/website/i18n).

Note that [you can only host one locale at a time](https://tutorial.docusaurus.io/docs/tutorial-extras/translate-your-site#start-your-localized-site) when hosting the website locally with `yarn dev`.

```sh
yarn dev -l ja # When you are checking the Japanese docs locally
```

### Working on packages

### Updating English docs

English docs are the source of truth for Riverpod docs. As such, translations
may get "out of date" for a period of time.  
To make it obvious for users that a translated page may be out of date, Riverpod's
website supports showing a warning banner at the top of the translation pages.

To support in a maintainable way, when editing English docs in a way that requires
translations to be updated, the English's "version number" needs to be bumped.  
**This does not need to be done when fixing typos**

To bump the version number of a page, you should either add or update
a `version: nbr` at the very top of the file.

For example:

```md
---
title: This is an example
version: 2
# ^ This number needs to be incremented.
# Doing so will show an outdated banner on all translations of this page.
---

Some content
```

#### Adding code snippets

Unless agree otherwise, all code snippets inside docs need to be placed in a `.dart` file
and then imported in `.mdx` files.  
This is important to enable static analysis of the code snippets, such that when
a breaking change happens, all associated snippets in the documentation that
need updating will be highlighted.

You can check out the [Getting Started] source for an example on how to do this.

At the same time, if you are working on a branch of the documentation
where the toggles for enabling/disabling code-generation and hooks are supported; then
your code snippets should support those.  
This is done by having a separate `.dart` file for each possible scenario.  
Again, look at the [Getting Started] for an example.

[Getting Started]: https://github.com/rrousselGit/riverpod/blob/master/website/docs/introduction/getting_started.mdx
