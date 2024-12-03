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

type Article struct {
	FileName string
	Slug     string
	Title    string
	Content  []string
}

var articles []Article

func init() {
	log.Println("Initializing articles...")
	files, err := os.ReadDir("content/articles")
	if err != nil {
		fmt.Printf("Error reading /content/articles/: %v\n", err)
		return
	}

	for _, file := range files {
		if filepath.Ext(file.Name()) == ".md" {
			content, err := os.ReadFile(filepath.Join("content/articles", file.Name()))
			if err != nil {
				fmt.Println("Error reading file:", err)
				continue
			}

			lines := strings.Split(string(content), "\n")
			if len(lines) > 0 {
				articles = append(articles, Article{
					FileName: file.Name(),
					Slug:     strings.TrimSuffix(file.Name(), filepath.Ext(file.Name())),
					Title:    strings.TrimPrefix(lines[0], "# "),
					Content:  lines[1:],
				})
			}
		}
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
