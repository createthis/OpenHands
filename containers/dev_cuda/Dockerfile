#FROM docker.openhands.dev/openhands/runtime:0.60-nikolaik
FROM openhands-jesse
RUN sudo apt update
RUN sudo apt install -y libtbb-dev libssl-dev libcurl4-openssl-dev libaio1 \
    libaio-dev libfmt-dev libgflags-dev zlib1g-dev patchelf cmake ccache
RUN pip3 install packaging ninja
RUN sudo apt install -y wget
RUN wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-debian12-12-8-local_12.8.1-570.124.06-1_amd64.deb
RUN sudo dpkg -i cuda-repo-debian12-12-8-local_12.8.1-570.124.06-1_amd64.deb
RUN sudo cp /var/cuda-repo-debian12-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update
RUN sudo apt-get -y install cuda-toolkit-12-8
RUN apt-get install -y cuda-drivers
USER root

WORKDIR /app

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["uvicorn", "openhands.server.listen:app", "--host", "0.0.0.0", "--port", "3000"]

