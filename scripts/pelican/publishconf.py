#!/usr/bin/env python3
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

# This file is only used if you use `make publish` or
# explicitly specify it as your config file.

import os
import sys
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__))))

from pelicanconf import *

# If your site is available via HTTPS, make sure SITEURL begins with https://
#SITEURL = os.getenv("SITEURL", "http://download.ecmwf.int/test-data/atlas/docs/site" )
SITEURL = os.getenv("SITEURL", "https://sites.ecmwf.int/docs/atlas" )

RELATIVE_URLS = False

FEED_ALL_ATOM = 'feeds/all.atom.xml'
CATEGORY_FEED_ATOM = 'feeds/{slug}.atom.xml'

DELETE_OUTPUT_DIRECTORY = False

# Following items are often useful when publishing

#DISQUS_SITENAME = ""
#GOOGLE_ANALYTICS = ""
