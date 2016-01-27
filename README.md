## docker-r-studio-exasol
Dockerized  Ubuntu base image (r-base) for RStudio (r-studio). The RStudio image contains all necessary packages including [r-exasol](https://github.com/EXASOL/r-exasol) to connect to EXASolution Database.

## Build images
```
docker build -t r-base:ubuntu-14.04 r-base/
docker build -t r-studio:ubuntu-14.04 r-studio/
```

## Start RStudio container
***Default*** (R-User: rstudio, R-Password: rstudio):
```
docker run -d \
    -p 8787:8787 \
    --name=rstudio \
    r-studio:ubuntu-14.04
```
***Customized*** by passing environment variables:
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
You can visit http://hostip:8787 to access RStudio.

## Connect to EXASolution from RStudio
1. Login to RStudio on http://<host>:8787
2. Load RODBC package```require(RODBC)```
3. Load r-exasol package```require(exasol)```
4. Establish ODBC connection
5. Check [r-exasol](https://github.com/EXASOL/r-exasol) repo for examples on read, write operations.

```{r}
## Using example from EXASOL/r-exasol repo /examples/createScript.R
require(RODBC)
require(exasol)

# Connect via RODBC with configured DSN
C <- odbcConnect("exasolution")

# Generate example data frame with two groups
# of random values with different means.
valsMean0  <- rnorm(10, 0)
valsMean50 <- rnorm(10, 50)
twogroups <- data.frame(group = rep(1:2, each = 10),
                        value = c(valsMean0, valsMean50))

# Write example data to a table
odbcQuery(C, "CREATE SCHEMA test")
odbcQuery(C, "CREATE TABLE test.twogroups (groupid INT, val DOUBLE)")
exa.writeData(C, twogroups, tableName = "test.twogroups")

# Create the R function as an UDF R script in the database
# In our case it computes the mean for each group.
testscript <- exa.createScript(
  C,
  "test.mymean",
  function(data) {
    data$next_row(NA); # read all values from this group into a single vector
    data$emit(data$groupid[[1]], mean(data$val))
  },
  inArgs = c( "groupid INT", "val DOUBLE" ),
  outArgs = c( "groupid INT", "mean DOUBLE" ) )

# Run the function, grouping by the groupid column
# and aggregating on the "val" column. This returns
# two values which are close to the means of the two groups.
testscript("groupid", "val", table = "test.twogroups" , groupBy = "groupid")
}
```
Here is a possible output of ```testscript()``` UDF:
```
GROUPID       MEAN
1       1  0.4798063
2       2 50.1477790
```

## Credits
The Dockerfiles for ```r-base``` and ```r-studio``` are from [rocker-org/rocker](https://github.com/rocker-org/rocker) and [rocker-org/hadleyvrse](https://github.com/rocker-org/hadleyverse). Thank you guys for your awesome work.
