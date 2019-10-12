#!/usr/bin/env python
import sys
from datetime import datetime as dt, timedelta
from astro_py import astro_py

class astro:
    def __ini__(self):
        a = astro_py.astro_py('2000/12/31', '12:24', '+02:00', '46n12', '6e9')
        return a.get_data()