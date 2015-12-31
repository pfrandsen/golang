package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
)

// Usage: go run build.go < input-file > output-file
//
// The script will scan the input and print each line to stdout
// If input line matches <!-- include(path) --> then this line will be
// replaced by the content of the file identified by 'path'

func main() {
	r := regexp.MustCompile("<!--\\s+include\\(\\s*(\\S+)\\s*\\)\\s+-->")
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		t := scanner.Text()
		if r.MatchString(t) {
			match := r.FindStringSubmatch(t)
			includeFile(match[1])
		} else {
			fmt.Println(t)
		}
	}
}

func includeFile(path string) {
	file, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
