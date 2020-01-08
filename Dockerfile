FROM alpine:latest
ARG SERVERFILE=CryoFall_Server_v0.24.10.18_NetCore
RUN wget "https://atomictorch.com/Files/${SERVERFILE}.zip" && \
    unzip -d / "${SERVERFILE}.zip"

FROM mcr.microsoft.com/dotnet/core/runtime:3.1
ARG SERVERFILE=CryoFall_Server_v0.24.10.18_NetCore
ENV USER=cryofall USER_ID=999 USER_GID=999
RUN mkdir /CryoFall
COPY --from=0 /${SERVERFILE}/ /CryoFall/

RUN groupadd --gid "${USER_GID}" "${USER}" && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash \
        ${USER}


COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
VOLUME [ "/CryoFall/Data" ]
EXPOSE 6000/udp
