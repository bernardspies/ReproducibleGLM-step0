MODELNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
MODELVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
MODELSRC  := $(shell basename `pwd`)
AUTHORNAME := "Steph Locke"
AUTHOREMAIL := "Steph@itsalocke.com"
RENDERDIR := "../new_version"

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

getrepo:
  git clone https://$(GITHUB_PAT)@github.com/$(TRAVIS_REPO_SLUG).git $(RENDERDIR);\
  git config --global user.name $(AUTHORNAME) ;\
  git config --global user.email $(AUTHOREMAIL)

analysis: getrepo
	Rscript -e 'rmarkdown::render("README.Rmd", output_format = "rmarkdown::github_document", output_dir="$(RENDERDIR)/docs")';\
  git commit -am "Documents produced in clean evironment via Travis $(TRAVIS_BUILD_NUMBER)" ;\
  git push --quiet origin master

