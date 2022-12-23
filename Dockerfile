FROM mcr.microsoft.com/oss/mirror/docker.io/library/ubuntu:20.04 AS build
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install wget build-essential \
    swig cmake git \
    libboost-filesystem-dev libboost-test-dev libboost-serialization-dev libboost-regex-dev libboost-serialization-dev libboost-regex-dev libboost-thread-dev libboost-system-dev

ENV PYTHONPATH=/app/Release

COPY CMakeLists.txt ./
COPY AnnService ./AnnService/
COPY Test ./Test/
COPY Wrappers ./Wrappers/
COPY GPUSupport ./GPUSupport/
COPY ThirdParty ./ThirdParty/

RUN mkdir build && cd build && cmake .. && make -j$(nproc) && cd ..
RUN ls -a


FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app2
COPY --from=build /app .
RUN ls -a
RUN dotnet --version

