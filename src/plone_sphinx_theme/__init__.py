"""
A Bootstrap-based Sphinx theme for documentation of Plone packages and projects, inheriting from Sphinx Book Theme and PyData Sphinx Theme.
"""
import os
from pathlib import Path

from sphinx.application import Sphinx
from sphinx.util import logging

__version__ = "1.4.0"

from sphinx_book_theme import update_context_with_repository_info, update_sourcename

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


# def update_templates(app, pagename, templatename, context, doctree):
#     """Update template names and assets for page build.
#
#     This is a copy of what the pydata theme does here to include a new section
#     - https://github.com/pydata/pydata-sphinx-theme/blob/0a4894fab49befc59eb497811949a1d0ede626eb/src/pydata_sphinx_theme/__init__.py#L173 # noqa: E501
#     """
#     # Allow for more flexibility in template names
#     template_sections = ["theme_footer_content_items"]
#     for section in template_sections:
#         if context.get(section):
#             # Break apart `,` separated strings so we can use , in the defaults
#             if isinstance(context.get(section), str):
#                 context[section] = [
#                     ii.strip() for ii in context.get(section).split(",")
#                 ]
#
#             # Add `.html` to templates with no suffix
#             for ii, template in enumerate(context.get(section)):
#                 if not os.path.splitext(template)[1]:
#                     context[section][ii] = template + ".html"


def setup(app: Sphinx):
    # Register theme
    theme_dir = get_html_theme_path()
    # Configure for your theme
    app.add_html_theme("plone_sphinx_theme", str(theme_dir))
    app.add_js_file("scripts/plone-sphinx-theme.js")

    # Events
    # app.connect("builder-inited", update_sourcename)
    # app.connect("builder-inited", update_context_with_repository_info)
    # app.connect("html-page-context", update_templates)

    # This extension has both theme-like and extension-like features.
    # Themes are initialised immediately before use, thus we cannot
    # rely on an event to set the config - the theme config must be
    # set in setup(app):
    update_general_config(app, app.config)
    # Meanwhile, extensions are initialised _first_, and any config
    # values set during setup() will be overwritten. We must therefore
    # register the `config-inited` event to set these config options
    app.connect("config-inited", update_general_config)
