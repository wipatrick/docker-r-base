## docker-r-studio-exasol
Dockerized  Ubuntu base image (r-base) for RStudio (r-studio). The RStudio image contains all necessary packages including [r-exasol](https://github.com/EXASOL/r-exasol) to connect to EXASolution Database.

## Build images
```
docker build -t r-base:ubuntu-14.04 r-base/
docker build -t r-studio:ubuntu-14.04 r-studio/
```

## Start RStudio container
1. Default (R-User: rstudio, R-Password: rstudio):
```
docker run -d \
    -p 8787:8787 \
    --name=rstudio \
    r-studio:ubuntu-14.04
```
2. Customized by passing environment variables:
```
docker run -d \
    -p 8787:8787 \
    -e EXAHOST="192.168.99.101" \
    -e EXAUSER="sys" \
    -e EXAPASSWORD="exasol" \
    -e ROOT="TRUE" \
    -e USER="rfoo" \
    -e PASSWORD="rbar" \
    --name=rstudio \
    r-studio:ubuntu-14.04
```
You can visit http://<host>:8787 to access RStudio.

## Connect to EXASolution from RStudio
1. Login to RStudio on http://<host>:8787
2. Load RODBC package via ```require(RODBC)```
3. Load r-exasol package via ```require(exasol)```
4. Establish ODBC connection
5. Check [r-exasol](https://github.com/EXASOL/r-exasol) repo for examples on read, write operations.

## Credits
The Dockerfiles for ```r-base``` and ```r-studio``` are from [rocker-org/rocker](https://github.com/rocker-org/rocker) and [rocker-org/hadleyvrse](https://github.com/rocker-org/hadleyverse). Thank you guys for your awesome work.
