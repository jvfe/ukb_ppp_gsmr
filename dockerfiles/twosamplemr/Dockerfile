FROM mrcieu/twosamplemr:0.5.11

LABEL image.author.name "jvfecav"

# Get Cpp
RUN apt-get update && \
    apt-get -y install gcc cmake mono-mcs libglpk-dev libxml2 libxml2-dev procps curl unzip libz-dev && \
    rm -rf /var/lib/apt/lists/*

RUN Rscript -e "install.packages(c('remotes'))"

RUN curl -L  https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20231211.zip -o plink.zip &&\
    unzip plink.zip &&\
    mv plink /usr/local/bin/ &&\
    rm plink.zip

CMD ["bash"]
WORKDIR /
