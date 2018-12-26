#!/usr/bin/env python
# -*- coding: utf-8 -*-
from setuptools import (
    find_packages,
    setup,
)
extra_require = {
    'remote': [
        "robotframework==3.0.4",
        "robotframework-seleniumlibrary==3.2.0",
        "robotframework-pabot==0.45",
    ]
}
setup(
	name='DaoTestAutomation',
	version='1.0',
	description="""dao-test-autoamtion-setup""",
    author='Michael Jimenez',
    author_email='michaeljimenez@digixglobal.com',
    extras_requires=extra_require,
    install_requires=[
    	"robotframework==3.0.4",
    	"robotframework-seleniumlibrary==3.2.0",
    	"robotframework-pabot==0.45",
    ],
    python_requires='>=3.5.3,<4',
)
