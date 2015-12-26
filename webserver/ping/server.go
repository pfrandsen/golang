package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"os/exec"
	"strconv"
	"unicode/utf8"
)

var listenPort int

func localIPs() string {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return ""
	}
	ips := ""
	for _, address := range addrs {
		// check address type and if it is not a loopback then add it to result
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				if utf8.RuneCountInString(ips) > 0 {
					ips = ips + ", "
				}
				ips = ips + ipnet.IP.String()
			}
		}
	}
	return ips
}

func uname() string {
	out, err := exec.Command("uname", "-a").Output()
	if err != nil {
		return "Unknown"
	}
	return string(out)
}

func lsb(field string) string {
	out, err := exec.Command("lsb_release", "-s", "-"+field).Output()
	if err != nil {
		return "Unknown"
	}
	return string(out)
}

func header(w http.ResponseWriter) {
	io.WriteString(w, "<html>\n")
	io.WriteString(w, "<head>\n")
	io.WriteString(w, "</head>\n")
	io.WriteString(w, "<body>\n")
}

func footer(w http.ResponseWriter) {
	io.WriteString(w, "</body>\n</html>\n")
	fmt.Fprintf(w, "</body>\n</html>\n")
}

func ping(w http.ResponseWriter, r *http.Request) {
	header(w)
	io.WriteString(w, "It's alive")
	footer(w)
}

func info(w http.ResponseWriter, r *http.Request) {
	host, _ := os.Hostname()
	header(w)
	io.WriteString(w, "<dl>")
	io.WriteString(w, "<dt>Hostname</dt><dd>"+host+"</dd>")
	io.WriteString(w, "<dt>Operating System</dt>")
	io.WriteString(w, "<dd><dl>")
	io.WriteString(w, "<dt>uname -a</dt><dd>"+uname()+"</dd>")
	io.WriteString(w, "<dt>lsb id</dt><dd>"+lsb("i")+"</dd>")
	io.WriteString(w, "<dt>lsb release</dt><dd>"+lsb("r")+"</dd>")
	io.WriteString(w, "<dt>lsb description</dt><dd>"+lsb("d")+"</dd>")
	io.WriteString(w, "<dt>lsb codename</dt><dd>"+lsb("c")+"</dd>")
	io.WriteString(w, "</dl></dd>")
	io.WriteString(w, "<dt>IP</dt><dd>"+localIPs()+"</dd>")
	io.WriteString(w, "<dt>Port</dt><dd>"+strconv.Itoa(listenPort)+"</dd>")
	io.WriteString(w, "<dt>Process id</dt><dd>"+strconv.Itoa(os.Getpid())+"</dd>")
	io.WriteString(w, "<dt>Parent process id</dt><dd>"+strconv.Itoa(os.Getppid())+"</dd>")
	io.WriteString(w, "<dt>User Agent</dt><dd>"+r.UserAgent()+"</dd>")
	io.WriteString(w, "</dl>")
	footer(w)
}

func main() {
	portPtr := flag.Int("port", 8000, "listen port")
	flag.Parse()
	listenPort = *portPtr
	http.HandleFunc("/info", info)
	http.HandleFunc("/", ping)
	fmt.Println("starting server, listening on port:", listenPort)
	err := http.ListenAndServe(":"+strconv.Itoa(listenPort), nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
