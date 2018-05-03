# get the base image
FROM rocker/verse:3.4.4

# required
MAINTAINER Emrah Er <eer@eremrah.com>

# get contents of GitHub repo
COPY . /wildcatdown

# go into the repo directory
RUN . /etc/environment \

  && sudo apt-get update \

&& sudo unzip wildcatdown/fonts.zip && cp fonts -r /usr/local/share/fonts \
&& sudo fc-cache -f -v \

  && R -e "devtools::install('/wildcatdown', dep=TRUE)" \

&& R -e "if (dir.exists('index')) unlink('index', recursive = TRUE)" \
&& R -e "rmarkdown::draft('index.Rmd', template = 'thesis', package = 'wildcatdown', create_dir = TRUE, edit = FALSE)" \
&& R -e "if (file.exists('index/_book/thesis.pdf')) file.remove('index/_book/thesis.pdf')" \
&& R -e "setwd('index');  bookdown::render_book('index.Rmd', wildcatdown::thesis_pdf(latex_engine = 'xelatex'))" \
&& R -e "file.exists('index/_book/thesis.pdf')"
