---
myst:
  html_meta:
    "description": "Contribute to Plone Sphinx Theme"
    "property=og:description": "Contribute to Plone Sphinx Theme"
    "property=og:title": "Contribute to Plone Sphinx Theme"
    "keywords": "Plone, Sphinx, Theme, plone-sphinx-theme, contribute, kitchen, sink, demonstration, demo, template, style, JavaScript"
---

# Contribute to Plone Sphinx Theme

This document describes how to install Plone Sphinx Theme for contributing code to this project, and what you can modify.
It also covers the essential commands for building and previewing


## Prerequisites

-   `uv`
-   {term}`GNU Make`


### `uv`

Install `uv` using the [standalone installer method](https://docs.astral.sh/uv/getting-started/installation/#standalone-installer).


## Install Plone Sphinx Theme

Begin by cloning the Plone Sphinx Theme repository from GitHub.

```shell
git clone https://github.com/plone/plone-sphinx-theme.git
```

Change your working directory to the cloned repository.

```shell
cd plone-sphinx-theme
```

Then install a supported Python version for development, create a Python virtual environment, install requirements for development, and install the package in development mode with a single command.

```shell
make dev
```

## Change log entry

Plone Sphinx Theme requires that you include a change log entry or news item with your contribution.
Your attribution must be in the format of `@github_username`.

```{seealso}
For details see {ref}`contributing-change-log-label`.
```

## Edit documentation

You can edit documentation located in the directory {file}`docs`, except for the files contained in `docs/reference/kitchen-sink`.

```{danger}
Do not directly edit files in the directory {file}`docs/reference/kitchen-sink`.
These files are copied from the source of the demonstration website [Sphinx Themes Gallery](https://sphinx-themes.org/) whenever there is an update to it.
See {ref}`update-kitchen-sink-demonstration` for details.
```


(update-kitchen-sink-demonstration)=

### Update Kitchen Sink demonstration

From time to time, the demonstration files for [Sphinx Themes Gallery](https://sphinx-themes.org/) need to be updated.
Plone Sphinx Theme uses these files as a demonstration for its styles.
To copy these updated files to Plone Sphinx Theme, run the following command.

```shell
make kitchen-sink-update
```


(override-build-configuration-options)=

### Override build configuration options

Both Sphinx and Vale support overriding configuration options.
The following examples serve as tips for spotting mistakes in your documentation when you have too many errors or warnings.

In Sphinx, you can use the `SPHINXOPTS` environment variable to set [configuration options](https://www.sphinx-doc.org/en/master/usage/configuration.html) of [`sphinx-build`](https://www.sphinx-doc.org/en/master/man/sphinx-build.html).
Syntax is in the following form.

```shell
make SPHINXOPTS="OPTION VALUE" BUILDER
```

The following example shows how to clean then build a live HTML preview of the documentation while suppressing syntax highlighting failures.

```shell
make SPHINXOPTS="-D suppress_warnings='misc.highlighting_failure'" clean livehtml
```

You can also pass options to Vale in the `VALEOPTS` environment variable.
In the following example, Vale will not return a non-zero exit code when there are errors and will display warnings or errors only, not suggestions.

```shell
make vale VALEOPTS="--no-exit --minAlertLevel='warning'"
```


## Edit the theme

You can edit the Plone Sphinx Theme's layout, content, styles, and JavaScripts.
This section describes how you can change this theme.

```{seealso}
{doc}`../reference/file-system-structure`
```


### Add or edit a template

Templates are pages of Jinja2 code into which components can be inserted.
Plone Sphinx Theme uses a template, {file}`404.html` to display an HTTP "404 Not Found" response page to visitors when they request a page that doesn't exist.
In Plone Sphinx Theme, templates are located in the directory {file}`src/plone_sphinx_theme/theme/plone-sphinx-theme`.


### Add or edit a component

Components are snippets of Jinja2 code that can be inserted in templates.
In Plone Sphinx Theme, components are located in the directory {file}`src/plone_sphinx_theme/theme/plone-sphinx-theme/components`.


### Add or edit styles

Plone Sphinx Theme uses Sass and webpack to compile a CSS file for its theme.
You can edit these files located in the directory {file}`src/plone_sphinx_theme/assets/styles`, except for those in {file}`src/plone_sphinx_theme/assets/styles/sphinx-book-theme`.

```{danger}
Do not directly edit files in the directory {file}`src/plone_sphinx_theme/assets/styles/sphinx-book-theme`.
These files are copied from the parent theme whenever there is an update to it.
See {ref}`update-parent-theme-styles` for details.
```


### Build and reload

Compile static assets, build and serve the docs, and reload the browser on changes.

```shell
make serve
```


### Compile static assets

After editing any of the static assets, you need to compile them.
This step is included in the `make serve` command.

```shell
make compile
```


(update-parent-theme-styles)=

#### Update parent theme styles

From time to time, the parent theme, Sphinx Book Theme, will update its Sass files.
Plone Sphinx Theme uses these files as a base for its styles.
To copy these updated files to Plone Sphinx Theme, run the following command.

```shell
make sbt-styles-update
```


### Add or edit JavaScripts

Plone Sphinx Theme uses webpack to compile a JavaScript file for its theme.
You can edit these files located in the directory {file}`src/plone_sphinx_theme/assets/scripts`.


## Update requirements

Requirements are managed with `uv` in the {file}`uv.lock`.
They are declared in the {file}`pyproject.toml`.

Update requirements in your development environment.

```shell
uv sync
```

Add a development requirement.

```shell
uv add --dev my-requirement
```


## Release

To release Plone Sphinx Theme, use the following command.

```shell
make release
```

This command runs [`zest.releaser`](https://pypi.org/project/zest.releaser/) to make a full release.
