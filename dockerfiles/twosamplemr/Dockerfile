FROM mrcieu/twosamplemr:0.5.11

LABEL image.author.name "jvfecav"

# Get Cpp
RUN apt-get update && \
    apt-get -y install gcc cmake mono-mcs libglpk-dev libxml2 libxml2-dev procps && \
    rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages(c('remotes'))"
RUN Rscript -e "remotes::install_github('explodecomputer/genetics.binaRies')"

CMD ["bash"]
WORKDIR /
