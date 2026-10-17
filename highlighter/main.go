package main

import (
	"fmt"
	"log"
	"os"
	"regexp"

	"github.com/ralscha/shiki-go"
)

func main() {
	lang := os.Args[1]
	code := os.Args[2]

	if _, err := shiki.BundledLanguage(lang); err != nil {
		fmt.Printf("<pre><code>%s</code></pre>", code)
		return
	}

	html, err := shiki.CodeToHTML(code, shiki.Options{
		Lang: lang,
		Themes: map[string]any{
			"light": "github-light-default",
			"dark":  "github-dark-default",
		},
		DefaultColor: "light-dark()",
	})
	if err != nil {
		log.Fatalf("Error while highlighting: %v\n", err)
	}

	shikiLightRe := regexp.MustCompile(`;?--shiki-light:#[a-fA-F0-9]+;?`)
	shikiDarkRe := regexp.MustCompile(`;?--shiki-dark:#[a-fA-F0-9]+;?`)
	html = shikiLightRe.ReplaceAllLiteralString(html, "")
	html = shikiDarkRe.ReplaceAllLiteralString(html, "")

	preAttrsRe := regexp.MustCompile(`<pre[^>]+>`)
	html = preAttrsRe.ReplaceAllLiteralString(html, "<pre>")
	fmt.Print(html)
}
