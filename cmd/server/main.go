package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type PageVars struct {
	TabTitle  string
	PageTitle string
}

func main() {
	// serve static files first
	fs := http.FileServer(http.Dir("web/static"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	http.HandleFunc("/", HomePage)
	log.Println("keshsad server starting on :42069")
	if err := http.ListenAndServe(":42069", nil); err != nil {
		log.Fatal(err)
	}
}

func HomePage(w http.ResponseWriter, r *http.Request) {
	// prep data for template
	pageVariables := PageVars{
		TabTitle:  "keshsad.com",
		PageTitle: "Welcome to keshsad.com",
	}

	// parse template
	tmpl, err := template.ParseFiles("web/templates/index.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// execute template
	if err := tmpl.Execute(w, pageVariables); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	} else {
		log.Println("homepage hit")
	}
}
