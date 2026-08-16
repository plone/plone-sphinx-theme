"""
A Bootstrap-based Sphinx theme for documentation of Plone packages and projects, inheriting from PyData Sphinx Theme.
"""
import os
from packaging.version import Version
from pathlib import Path
from typing import Dict

from sphinx.application import Sphinx
from sphinx.util import logging

__version__ = "1.4.4.dev0"

logger = logging.getLogger(__name__)


def get_html_theme_path():
    """Return list of HTML theme paths."""
    parent = Path(__file__).parent.resolve()
    # Configure for your theme
    theme_path = parent / "theme" / "plone-sphinx-theme"
    return theme_path


def update_general_config(app, config):
    theme_dir = get_html_theme_path()
    config.templates_path.append(os.path.join(theme_dir))
    config.templates_path.append(os.path.join(theme_dir, "components"))


def set_theme_version(
        app: Sphinx, pagename: str, templatename: str, context, doctree
) -> None:
    """Update the theme_version context variable."""
    context["pst_theme_version"] = Version(str(__version__)).base_version


def setup(app: Sphinx) -> Dict[str, str]:
    # Register theme
    theme_dir = get_html_theme_path()
    # Configure for your theme
    app.add_html_theme("plone_sphinx_theme", str(theme_dir))
    # Events
    app.connect("html-page-context", set_theme_version)
    # This extension has both theme-like and extension-like features.
    # Themes are initialised immediately before use, thus we cannot
    # rely on an event to set the config - the theme config must be
    # set in setup(app):
    update_general_config(app, app.config)
    # Meanwhile, extensions are initialised _first_, and any config
    # values set during setup() will be overwritten. We must therefore
    # register the `config-inited` event to set these config options
    app.connect("config-inited", update_general_config)
