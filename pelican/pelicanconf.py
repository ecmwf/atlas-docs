import shutil
import logging

AUTHOR = 'Willem Deconinck'

#M_SITE_LOGO = 'gr/logo.png'
M_SITE_LOGO_TEXT = 'Atlas'

SITENAME = 'Atlas'
SITESUBTITLE = 'Library for NWP and Climate data structures'
SITEURL = ''

M_BLOG_NAME = 'Atlas Blog'
M_BLOG_URL = 'blog/'

PATH = 'content'

STATIC_URL = 'content/{path}'
STATIC_SAVE_AS = 'content/{path}'
STATIC_PATHS = ['img', 'showcase']
EXTRA_PATH_METADATA = {'img/favicon.ico': {'path': '../favicon.ico'}}

ARTICLE_PATHS = ['blog']
ARTICLE_EXCLUDES = ['blog/authors', 'blog/categories', 'blog/tags']

PAGE_PATHS = ['']
PAGE_EXCLUDES = ['doc', 'img']
READERS = {'html': None} # HTML files are only ever included from reST

PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'

ARCHIVES_URL = 'blog/'
ARCHIVES_SAVE_AS = 'blog/index.html'
ARTICLE_URL = 'blog/{slug}/' # category/ is part of the slug
ARTICLE_SAVE_AS = 'blog/{slug}/index.html'
DRAFT_URL = 'blog/{slug}/' # so the URL is the final one
DRAFT_SAVE_AS = 'blog/{slug}/index.html'
AUTHOR_URL = 'blog/author/{slug}/'
AUTHOR_SAVE_AS = 'blog/author/{slug}/index.html'
CATEGORY_URL = 'blog/{slug}/'
CATEGORY_SAVE_AS = 'blog/{slug}/index.html'
TAG_URL = 'blog/tag/{slug}/'
TAG_SAVE_AS = 'blog/tag/{slug}/index.html'

AUTHORS_SAVE_AS = None # Not used
CATEGORIES_SAVE_AS = None # Not used
TAGS_SAVE_AS = None # Not used

PAGINATION_PATTERNS = [(1, '{base_name}/', '{base_name}/index.html'),
                       (2, '{base_name}/{number}/', '{base_name}/{number}/index.html')]

TIMEZONE = 'Europe/Prague'

DEFAULT_LANG = 'en'

import platform
if platform.system() == 'Windows':
    DATE_FORMATS = {'en': ('usa', '%b %d, %Y')}
else:
    DATE_FORMATS = {'en': ('en_US.UTF-8', '%b %d, %Y')}

FEED_ATOM = None
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

atlas_docs = "//download.ecmwf.int/test-data/atlas/docs"
latest_atlas_docs = "c++"
enable_blog = False

M_LINKS_NAVBAR1 = [('Tools', 'tools/', 'tools', [
                        ('atlas-grids','tools/atlas-grids',''),
                        ('atlas-meshgen','tools/atlas-meshgen',''),
                        ('atlas-gaussian-latitudes','tools/atlas-gaussian-latitudes','')]),
                   ('Design', 'design/', 'design', [
                        ('Object oriented design','design/object_oriented',''),
                        ('Grid','design/grid',''),
                        ('Mesh','design/mesh',''),
                        ('Plugin architecture','design/plugin_architecture','')]),
                   ('Getting Started', 'getting_started/', 'getting_started', [
                        ('Downloading and building', 'getting_started/installation',''),
                        ('Linking Atlas into your project', 'getting_started/linking','')]),
                   ('Docs', latest_atlas_docs+'/', '', [
                        ('C++ API', latest_atlas_docs+'/', ''),
                        ('Fortran API [TODO]', '', '')])]

M_LINKS_NAVBAR2 = []
if enable_blog:
    M_LINKS_NAVBAR2 += [('Blog', M_BLOG_URL, '[blog]', [])]
M_LINKS_NAVBAR2 += [ ('GitHub', 'https://github.com/ecmwf/atlas', '', [
                        ('Contact', 'contact/', 'contact'),
                        ('About', 'about/', 'about')]) ]

M_LINKS_FOOTER1 = [('Atlas', 'index.html'),
                   ('Getting started','getting_started'),
                   ('Design', 'design/')]

M_LINKS_FOOTER2 = [('Docs', latest_atlas_docs+'/'),
                   ('C++ API', latest_atlas_docs),
                   ('Fortran API [TODO]', '')]

M_LINKS_FOOTER3 = [('Contact Us', 'contact/')]
if enable_blog:
  M_LINKS_FOOTER3 += [('Blog Feed', M_BLOG_URL + '/feeds/all.atom.xml')]
M_LINKS_FOOTER3 += [('GitHub', 'https://github.com/ecmwf/atlas'),
                    ('About the Project', 'about/')]

M_LINKS_FOOTER4 = []#('Ha', 'contact/')]

M_CSS_FILES = ['https://fonts.googleapis.com/css?family=Source+Code+Pro:400,400i,600%7CSource+Sans+Pro:400,400i,600,600i&subset=latin-ext',
               'static/m-dark.css']

M_FINE_PRINT = """
| Atlas. Copyright © `ECMWF <http://ecmwf.int>`_. Site powered by `Pelican <https://getpelican.com>`_
  and `m.css <https://mcss.mosra.cz>`_.
  Contact the team via `GitHub <https://github.com/ecmwf/atlas>`_
"""

M_ARCHIVED_ARTICLE_BADGE = """
.. note-warning:: Archived article

    This article is from {year}. While great care is taken to keep information
    up-to-date, please note that not everything in this article might reflect
    current state of the Magnum project, external links might be dead and
    content might be preserved in its original form for archival purposes. Even
    the typos.
"""


if enable_blog:
  # Uncomment to enable link on landing page to blog
  M_NEWS_ON_INDEX = ("Latest news on our blog", 3)

DEFAULT_PAGINATION = 10

PLUGIN_PATHS = ['m.css/plugins']
PLUGINS = ['m.abbr',
           'm.alias',
           'm.code',
           'm.components',
           'm.dot',
           'm.dox',
           'm.filesize',
           'm.gh',
           'm.gl',
           'm.htmlsanity',
           'm.images',
           'm.link',
           'm.math',
           'm.metadata',
           #'m.plots',
           'm.sphinx',
           'm.vk']

FORMATTED_FIELDS = ['summary', 'description', 'landing', 'badge', 'header', 'footer']

THEME = 'm.css/pelican-theme/'
THEME_STATIC_DIR = 'static/'

M_THEME_COLOR = '#22272e'
M_SHOW_AUTHOR_LIST = True

M_HTMLSANITY_SMART_QUOTES = True
M_HTMLSANITY_HYPHENATION = True
M_DOX_TAGFILES = [
#     ('external/stl.tag', 'https://en.c++reference.com/w/', [], ['m-flat']),
      ('build/doxygen/atlas.tag', '/'+latest_atlas_docs+'/', ['atlas::'], ['m-flat', 'm-text', 'm-strong']),
#     ('content/doc/magnum.tag', 'https://doc.magnum.graphics/magnum/', ['Magnum::'], ['m-flat', 'm-text', 'm-strong'])
]
# M_SPHINX_INVENTORIES = [
#     ('external/python.inv', 'https://docs.python.org/3/', [], ['m-flat']),
#     ('external/numpy.inv', 'https://docs.scipy.org/doc/numpy/', [], ["m-flat"]),
#     ('external/scipy.inv', 'https://docs.scipy.org/doc/scipy/reference/', [], ["m-flat"]),
#     # It's in external instead of content/doc because there's already
#     # https://doc.magnum.graphics/python/objects.inv that people can download
#     ('external/magnum.inv', 'https://doc.magnum.graphics/python/', ['corrade.', 'magnum.'], ['m-flat', 'm-text', 'm-strong'])
# ]
M_IMAGES_REQUIRE_ALT_TEXT = True
M_METADATA_AUTHOR_PATH = 'blog/authors'
M_METADATA_CATEGORY_PATH = 'blog/categories'
M_METADATA_TAG_PATH = 'blog/tags'

try_with_latex = True
if not shutil.which('latex') or not try_with_latex :
    logging.warning("LaTeX not found, fallback to rendering math as code")
    M_MATH_RENDER_AS_CODE = True



DIRECT_TEMPLATES = ['archives']
PAGINATED_TEMPLATES = {'archives': None, 'tag': None, 'category': None, 'author': None}

SLUGIFY_SOURCE = 'basename'
PATH_METADATA = '(blog/)?(?P<slug>.+).rst'
SLUG_REGEX_SUBSTITUTIONS = [
        (r'[^\w\s-]', ''),  # remove non-alphabetical/whitespace/'-' chars
        (r'(?u)\A\s*', ''),  # strip leading whitespace
        (r'(?u)\s*\Z', ''),  # strip trailing whitespace
        (r'[-\s]+', '-'),  # reduce multiple whitespace or '-' to single '-'
        (r'C\+\+', 'c++'),
    ]
