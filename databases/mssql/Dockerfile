# We choose exact tag (not 'latest'), to be sure that new version won't break creating image
FROM mcr.microsoft.com/mssql/server:2017-CU17-ubuntu

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN chmod +x /usr/src/app/run-initialization.sh

ENV MSSQL_SA_PASSWORD Test@123
ENV ACCEPT_EULA Y
ENV MSSQL_PID Express

# Expose port 1433 in case accesing from other container
EXPOSE 1433

# Run Microsoft SQl Server and initialization script (at the same time)
# Note: If you want to start MsSQL only (without initialization script) you can comment bellow line out, CMD entry from base image will be taken
CMD /bin/bash ./entrypoint.sh