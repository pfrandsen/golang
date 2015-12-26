package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
)

func main() {
	workingDir, err := os.Getwd()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	pathPtr := flag.String("path", workingDir+"/content", "static files directory")
	portPtr := flag.Int("port", 8000, "listen port")
	flag.Parse()
	if info, err := os.Stat(*pathPtr); err == nil && info.IsDir() {
		fmt.Println("starting server, listening on port:", *portPtr)
		fmt.Println("serving files from:", *pathPtr)
		log.Fatal(http.ListenAndServe(":"+strconv.Itoa(*portPtr), http.FileServer(http.Dir(*pathPtr))))
	} else {
		log.Fatal("Content location '" + *pathPtr + "' does not exist or is not a directory")
	}
}
