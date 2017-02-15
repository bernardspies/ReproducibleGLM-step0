MODELNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
MODELVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
MODELSRC  := $(shell basename `pwd`)
AUTHORNAME := "Steph Locke"
AUTHOREMAIL := "Steph@itsalocke.com"

all: check clean

build:
	cd ..;\
	R CMD build  --no-manual $(MODELSRC)

install: build
	cd ..;\
	R CMD INSTALL $(MODELNAME)_$(MODELVERS).tar.gz

check: build
	cd ..;\
	R CMD check $(MODELNAME)_$(MODELVERS).tar.gz

clean:
	cd ..;\
	$(RM) -r $(MODELNAME).Rcheck/

analysis:
	Rscript -e 'rmarkdown::render("README.Rmd", output_format = "rmarkdown::github_document", output_dir="docs")';\
  git clone https://$(GITHUB_PAT)@github.com/$(TRAVIS_REPO_SLUG).git ../new_version;\
  git config user.name $(AUTHORNAME) ;\
  git config user.email $(AUTHOREMAIL) ;\
  cp docs/ ../new_version/ ;\
  cd ../new_version ;\
  git commit -am "Documents produced in clean evironment via Travis $(TRAVIS_BUILD_NUMBER)" ;\
  git push --quiet origin master

