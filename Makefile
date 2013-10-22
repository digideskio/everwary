all: runserver

migration: env
	${MAKE} --directory=camden migration

migrate: env
	${MAKE} --directory=camden migrate

runserver: env
	${MAKE} --directory=camden runserver

dbshell: env
	${MAKE} --directory=camden dbshell

env: requirements.txt
	curl -O http://python-distribute.org/distribute_setup.py
	curl -O https://raw.github.com/pypa/virtualenv/master/virtualenv.py
	curl -O https://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz
	curl -O https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz
	python2.7 -B -c 'from distribute_setup import download_setuptools; t = download_setuptools(); print t'
	python2.7 virtualenv.py --distribute --no-site-packages env
	rm -rf distribute_setup.py* virtualenv.py* setuptools-1.1.6.tar.gz pip-1.4.1.tar.gz distribute-*.tar.gz
	env/bin/pip install --upgrade distribute
	env/bin/pip install -r requirements.txt

test: env
	${MAKE} --directory=camden test

verify:
	pyflakes -x W camden
	pep8 --exclude=migrations --ignore=E501,E225 camden

minify:
	yuicompressor camden/main/static/css/base.css -o camden/main/static/css/base.min.css
	yuicompressor camden/main/static/js/main.js -o camden/main/static/js/main.min.js

deploy: minify
	rsync -vr * btimby@sfileapp.com:/usr/local/smartfile/apps/camden/ --exclude=env --delete --exclude=.svn --exclude=*.pyc

clean:
	find . -name *.pyc -delete

distclean: clean
	rm -rf env
