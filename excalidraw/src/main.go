// Serve excalidraw directory over HTTP
package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

const DEFAULT_PORT = "3000"
const DEFAULT_SERVE_FOLDER = "./static"

func main() {

	// Get the port from the environment variable, or use the default port
	port := os.Getenv("PORT")
	if port == "" {
		port = DEFAULT_PORT
	}

	log.Printf("Starting server...")

	// Local directory to serve
	fs := http.FileServer(http.Dir(DEFAULT_SERVE_FOLDER))

	// Attach the FileServer to a URL path
	http.Handle("/", fs)

	// Start the HTTP server
	log.Printf("Server started on port %s", port)
	err := http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}
