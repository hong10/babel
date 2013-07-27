test: import-cldr
	@py.test tests

create-test-env:
	@virtualenv test-env
	@test-env/bin/pip install pytest
	@test-env/bin/pip install --editable .

standalone-test: import-cldr create-test-env
	@test-env/bin/py.test tests

clean: clean-cldr clean-pyc

import-cldr:
	@./scripts/download_import_cldr.py

clean-cldr:
	@rm babel/localedata/*.dat
	@rm babel/global.dat

clean-pyc:
	@find . -name '*.pyc' -exec rm {} \;
	@find . -name '__pycache__' -type d | xargs rm -rf

develop:
	@pip install --editable .

tox-test:
	@PYTHONDONTWRITEBYTECODE= tox
	@$(MAKE) clean-pyc

upload-docs:
	$(MAKE) -C docs html dirhtml latex
	$(MAKE) -C docs/_build/latex all-pdf
	cd docs/_build/; mv html babel-docs; zip -r babel-docs.zip babel-docs; mv babel-docs html
	rsync -a docs/_build/dirhtml/ pocoo.org:/var/www/babel.pocoo.org/docs/
	rsync -a docs/_build/latex/Babel.pdf pocoo.org:/var/www/babel.pocoo.org/docs/babel-docs.pdf
	rsync -a docs/_build/babel-docs.zip pocoo.org:/var/www/babel.pocoo.org/docs/babel-docs.zip

release:
	python scripts/make-release.py

.PHONY: test develop tox-test clean-pyc clean-cldr import-cldr clean release upload-docs create-test-env standalone-test
