#Static files web server#

##Build and run##
1. ./build.sh (or go build static.go) - use ./arm-build.sh if building for ARM processor
2. ./static -port=&lt;port&gt; -path=&lt;path to content directory&gt;

Default port is 8000. Default content location is current working directory + "/content"

Example run commands:
* **./static** (serves files from 'content' subdirectory on port 8000)
* **./static -port=8080 -path=&#96;pwd&#96;/other** (serves files from 'other' subdirectory on port 8080)

Point browser to [http://localhost:8000/](http://localhost:8000/) or [http://localhost:8080/](http://localhost:8080/) to list files in the given content directory.
