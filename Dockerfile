FROM mcr.microsoft.com/mssql/server:2017-latest
    
    ENV ACCEPT_EULA=Y
    ENV SA_PASSWORD=abcDEF123#
    ENV MSSQL_PID=Developer
    ENV MSSQL_TCP_PORT=1433

    WORKDIR /src

    # Copy file from current dir (that runs docker build) to docker container dir
    COPY filldata.sql ./filldata.sql

    # RUN SQL SERVER and Access SQL CLI on localhost with given credentials 
    # Then run SQL Script - filldata.sql
    RUN (/opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started" &&  /opt/mssql-tools/bin/sqlcmd -S127.0.0.1 -Usa -PabcDEF123# -i filldata.sql