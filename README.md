# Setup Dockerfile with SQL Server image

- Great start to learn docker to built docker images and dockerfile

**What will be cover:**
- Basic docker commands
- Setup resource to build Docker image
- Create Dockerfile to setup SQL SERVER 2017 with SQL scripts to fill in random data
- Prefill the Server with some dummy database, table, and records
Links to Instructions: 


## Pull and modify SQL Server 2017 image
> Pull SQL Server Linux container - SQL Server 2017
> ```sh
> docker pull mcr.microsoft.com/mssql/server:2017-latest
> ```
> Run docker container -e = environment variable
> ```sh
> docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=abcDEF123#" \
> -p 1433:1433 --name sqlsv \
> -d mcr.microsoft.com/mssql/server:2017-latest
> ```
> Connect to container shell
> ```sh
> docker exec -it sqlsv bash
> ```
> Use sqlcmd tool inside container
> ```sh
> /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "abcDEF123#"
> ```
> Run SQL Command to add new Database
> ```sql
> CREATE DATABASE MYDB
> SELECT Name from sys.Databases
> GO
> ```
> ## Commit Image
> ```sh
> docker commit sqlsv youruser/docker-sql:initial
> ```
> Push docker image to dockerhub
> ```sh
> docker login --username=yourusername
> docker push yourusername/docker-sql:initial
> ```

## Dockerfile
> First: Change directory to the current folder that has Dockerfile
>
> Build the docker file using current directory
> 
> ```sh
> docker build -t youruser/sql-gen:initial .
> ```
> Run the newly built images
> ```sh
> docker run -d -p 1433:1433 --name sqlgen youruser/sql-gen:initial
> ```


## Docker Commands

| COMMANDS                                                    | DESCRIPTION                                            |
|-------------------------------------------------------------|--------------------------------------------------------|
| docker pull <image_source>                                  | Pull image from the given source                       |
| docker run -p <host>:<container> -d <image_id_or_name>      | Run container from image                               |
|                                                             | -d = detach mode run in bg                             |
|                                                             | -p = port mapping between host:container               |
| docker exec -it <container_id_or_name> <shell>              | Run command on the running container                   |
|                                                             | -i = keep STDIN open                                   |
|                                                             | -t Allocate psuedo-TTY                                 |
| docker commit <container_id_or_name> <image-name>:<version> | Create docker image from container with                |
|                                                             | the given name and version                             |
| docker login <server>                                       | Login to given server OR dockerhub registry by default |
| docker push <image-name>:<version>                          | Push image to the registry source                      |
|                                                             | - If version not give will be tag as latest            |

## Dockerfile Commands

| Steps #     | What it does?                                                            |
|-------------|--------------------------------------------------------------------------|
| 1 - FROM    | Starts with base image SQL Server                                        |
| 2 - ENV     | Set environment variables needed to setup SQL Server                     |
| 3 - WORKDIR | Create new folder inside docker and use that directory for other command |
| 4 - COPY    | Copy auto generated data sql scripts to src folder                       |
| 5 - RUN     | startup sqlserver and execute sqlcommand to run filldata.sql script      |
