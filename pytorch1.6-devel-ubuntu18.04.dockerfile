ARG BASE=yellow.hub.cambricon.com/pytorch/base/x86_64/pytorch:v0.5-x86_64-ubuntu18.04-torch_py36_gcc7_mpi
FROM ${BASE}

ARG CNTOOLKIT_VERSION=3.1.1-1
ARG CNNL_VERSION=1.13.1-1
#ARG CNNL_EXTRA_VERSION=0.8.0-1
ARG CNCL_VERSION=1.2.1-1
ARG CNCV_VERSION=1.0.0-1
ARG MAGICMIND_VERSION=0.13.1-1
ARG MLUOPS_VERSION=0.2.0-1

RUN apt update && \
    apt install -y gdb valgrind language-pack-zh-hans

RUN cd /tmp && \
    wget -O cntoolkit_install_pkg.deb http://daily.software.cambricon.com/release/cntoolkit/Linux/x86_64/Ubuntu/18.04/${CNTOOLKIT_VERSION}/cntoolkit_${CNTOOLKIT_VERSION}.ubuntu18.04_amd64.deb && \
    dpkg -i cntoolkit_install_pkg.deb && \
    apt update && \
    apt-get install -y cnrt cnperf cnpapi cnlicense cngdb cndrv cndev cncodec cncc cnas cnbin cnstudio cnrtc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cntoolkit-* && \
    rm -f /etc/apt/sources.list.d/cntoolkit-*.list && \
    rm -f cntoolkit_install_pkg.deb

RUN cd /tmp && \
    wget -O cnnl_install_pkg.deb http://daily.software.cambricon.com/release/cnnl/Linux/x86_64/Ubuntu/18.04/${CNNL_VERSION}/cnnl_${CNNL_VERSION}.ubuntu18.04_amd64.deb && \
    dpkg -i cnnl_install_pkg.deb && \
    rm -f cnnl_install_pkg.deb

# RUN cd /tmp && \
#     wget -O cnnl_extra_install_pkg.deb http://daily.software.cambricon.com/release/cnnlextra/Linux/x86_64/Ubuntu/18.04/${CNNL_EXTRA_VERSION}/cnnlextra_${CNNL_EXTRA_VERSION}.ubuntu18.04_amd64.deb && \
#     dpkg -i cnnl_extra_install_pkg.deb && \
#     rm -f cnnl_extra_install_pkg.deb

RUN cd /tmp && \
    wget -O cncl_install_pkg.deb http://daily.software.cambricon.com/release/cncl/Linux/x86_64/Ubuntu/18.04/${CNCL_VERSION}/cncl_${CNCL_VERSION}.ubuntu18.04_amd64.deb && \
    dpkg -i cncl_install_pkg.deb && \
    rm -f cncl_install_pkg.deb

RUN cd /tmp && \
    wget -O cncv_install_pkg.deb http://daily.software.cambricon.com/release/cncv/Linux/x86_64/Ubuntu/18.04/${CNCV_VERSION}/cncv_${CNCV_VERSION}.ubuntu18.04_amd64.deb && \
    dpkg -i cncv_install_pkg.deb && \
    rm -f cncv_install_pkg.deb

RUN cd /tmp && \
    wget -O cncl_install_pkg.deb http://daily.software.cambricon.com/release/cncl/Linux/x86_64/Ubuntu/18.04/${CNCL_VERSION}/cncl_${CNCL_VERSION}.ubuntu18.04_amd64.deb && \
    dpkg -i cncl_install_pkg.deb && \
    rm -f cncl_install_pkg.deb

RUN cd /tmp && \
    wget -O mluops_install_pkg.deb http://daily.software.cambricon.com/release/mluops/Linux/x86_64/Ubuntu/18.04/${MLUOPS_VERSION}/mluops_${MLUOPS_VERSION}.ubuntu18.04_amd64.deb && \
    dpkg -i mluops_install_pkg.deb && \
    rm -f mluops_install_pkg.deb

ENV NEUWARE_HOME=/usr/local/neuware
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NEUWARE_HOME/lib64

RUN chmod 777 -R /root

