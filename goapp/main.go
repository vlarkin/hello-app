package main

import (
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

const (
	FrontendPort = "8080"
	APIPort      = "9090"
)

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		startTime := time.Now()

		next.ServeHTTP(w, r)

		duration := time.Now().Sub(startTime)
		log.Printf("%s %s %s\n", r.Method, r.RequestURI, duration)
	})
}

func main() {

	dir := os.Getenv("HTML_DIR")
	if dir == "" {
		dir = "./html"
	}
	fs := http.FileServer(http.Dir(dir))
	http.Handle("/", loggingMiddleware(http.StripPrefix("/", fs)))

	log.Printf("Frontend Listening on port %s\n", FrontendPort)
	go func() {
		err := http.ListenAndServe("0.0.0.0:"+FrontendPort, nil)
		if err != nil {
			log.Fatal(err)
		}
	}()

	apiHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_, err := w.Write([]byte("Payload received: "))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = io.Copy(w, r.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	})

	apiServer := http.NewServeMux()
	apiServer.Handle("/api", loggingMiddleware(apiHandler))

	apiServer.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{ "alive" }`))
		if err != nil {
			log.Fatal(err)
		}
	})

	log.Printf("API Listening on port %s\n", APIPort)
	err := http.ListenAndServe("0.0.0.0:"+APIPort, apiServer)
	if err != nil {
		log.Fatal(err)
	}
}
