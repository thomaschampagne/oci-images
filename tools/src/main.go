package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

const (
	DEFAULT_PORT         = "3000"
	DEFAULT_SERVE_FOLDER = "./static"
	INDEX_FILE           = "index.html"
)

func main() {

	port := getEnv("PORT", DEFAULT_PORT)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Build the full path to the requested file
		requestedPath := filepath.Join(DEFAULT_SERVE_FOLDER, r.URL.Path)

		// Check if the requested file exists
		if _, err := os.Stat(requestedPath); err == nil {
			http.ServeFile(w, r, requestedPath)
			return
		}

		// Fallback to serving index.html (URL rewrite)
		http.ServeFile(w, r, filepath.Join(DEFAULT_SERVE_FOLDER, INDEX_FILE))
	})

	log.Printf("Server running at http://localhost:%s", port)
	if err := http.ListenAndServe(fmt.Sprintf(":%s", port), nil); err != nil {
		log.Fatal(err)
	}
}

func getEnv(name string, defaultValue string) string {
	envValue := os.Getenv(name)
	if envValue == "" {
		return defaultValue
	}
	return envValue
}
