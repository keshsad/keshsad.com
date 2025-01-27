package main

import (
	"fmt"
	"html/template"
	"net/http"
)

func main() {
	fmt.Println("hello from main")

	http.HandleFunc("/", handleIndex)
	http.ListenAndServe(":42069", nil)
}

func handleIndex(w http.ResponseWriter, r *http.Request) {
	fmt.Println("hello from index")

	tmpl, err := template.ParseFiles("./index.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	tmpl.Execute(w, nil)
}
