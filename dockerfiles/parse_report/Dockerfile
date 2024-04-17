FROM biocontainers/seaborn:0.12.2_cv1

LABEL image.author.name "jvfecav"

# Get Cpp
RUN apt-get update && \
    apt-get -y install gcc cmake mono-mcs libglpk-dev libxml2 libxml2-dev procps && \
    rm -rf /var/lib/apt/lists/*

RUN pip install scipy
