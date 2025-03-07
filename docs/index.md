---
myst:
  html_meta:
    "description": "Plone Sphinx Theme is the official Sphinx theme for documentation of Plone 6, Plone Conference trainings, and documentation of various Plone packages."
    "property=og:description": "Plone Sphinx Theme is the official Sphinx theme for documentation of Plone 6, Plone Conference trainings, and documentation of various Plone packages."
    "property=og:title": "Plone Sphinx Theme"
    "keywords": "Plone, Sphinx, Theme, plone-sphinx-theme"
---

# Plone Sphinx Theme

[Plone Sphinx Theme](https://github.com/plone/plone-sphinx-theme) is the official Sphinx theme for [documentation of Plone 6](https://6.docs.plone.org/), [Plone Conference trainings](https://training.plone.org/), and documentation of various Plone packages.

It uses [Markedly Structured Text (MyST)](https://myst-parser.readthedocs.io/en/latest/), a rich and extensible flavor of Markdown for authoring documentation that combines the simplicity of CommonMark with the features of reStructuredText.

Plone Sphinx Theme requires Python {SUPPORTED_PYTHON_VERSIONS}.


```{todo}
`plone/cookie-documentation` generates a customized project based on `plone/plone-sphinx-theme`.
```

 ```{toctree}
:caption: How to guides
:hidden: true
:maxdepth: 2

guides/usage
guides/contributing-policies
guides/contribute
guides/develop
```

```{toctree}
:caption: Reference
:hidden: true
:maxdepth: 2

reference/file-system-structure
reference/kitchen-sink/index
reference/special-theme-elements
reference/extensions
```

```{toctree}
:maxdepth: 2
:hidden: true
:caption: Appendices

glossary
```