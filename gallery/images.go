package main

import (
	"bytes"
	"fmt"
	"image"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"strings"
	"sync"

	"github.com/gen2brain/gav1d/avif"
	_ "github.com/gen2brain/h265/heic"
	"golang.org/x/image/draw"
	"golang.org/x/sync/errgroup"
)

const WIDTH int = 800

func main() {
	file, err := os.ReadFile("dist/gallery/index.html")
	if err != nil {
		log.Fatalln("error reading dist/gallery/index.html: ", err)
	}

	mu := sync.Mutex{}
	eg := errgroup.Group{}
	eg.SetLimit(runtime.GOMAXPROCS(0))

	re := regexp.MustCompile(`img src="([^"]*)"`)

	for _, match := range re.FindAllSubmatch(file, -1) {
		eg.Go(func() error {
			imgSrc := string(match[1])
			outPath := "dist" + imgSrc
			srcPath := strings.ReplaceAll(imgSrc, "/gallery/", "gallery/assets/")
			srcPath = strings.ReplaceAll(srcPath, ".avif", ".heic")

			if err := os.MkdirAll(filepath.Dir(outPath), 0o750); err != nil {
				return fmt.Errorf("error creating output dir %s: %v", filepath.Dir(outPath), err)
			}
			width, height, err := optimise(srcPath, outPath, WIDTH)
			if err != nil {
				return err
			}
			mu.Lock()
			file = bytes.ReplaceAll(
				file,
				fmt.Appendf([]byte{}, `<img src="%s"`, imgSrc),
				fmt.Appendf([]byte{}, `<img src="%v" width="%d" height="%d"`, imgSrc, width, height),
			)
			mu.Unlock()
			return nil
		})
	}
	if err := eg.Wait(); err != nil {
		log.Fatalln("error while optimising images:", err)
	}
	if err := os.WriteFile("dist/gallery/index.html", file, 0o660); err != nil {
		log.Fatalln("error writing dist/gallery/index.html:", err)
	}
}

func optimise(srcPath, outPath string, width int) (int, int, error) {
	if f, err := os.Open(outPath); err == nil {
		defer f.Close()
		cfg, _, err := image.DecodeConfig(f)
		if err != nil {
			return 0, 0, fmt.Errorf("error decoding image %s: %v", outPath, err)
		}
		fmt.Println("skipped", outPath)
		return cfg.Width, cfg.Height, nil
	}
	file, err := os.Open(srcPath)
	if err != nil {
		return 0, 0, fmt.Errorf("error opening file: %v", err)
	}
	defer file.Close()
	img, _, err := image.Decode(file)
	if err != nil {
		return 0, 0, fmt.Errorf("error decoding HEIC image: %v", err)
	}
	srcWidth, srcHeight := img.Bounds().Dx(), img.Bounds().Dy()
	resizedWidth, resizedHeight := srcWidth, srcHeight
	if width != 0 {
		resizedWidth, resizedHeight = width, srcHeight*width/srcWidth
	}
	dst := image.NewRGBA(image.Rect(0, 0, resizedWidth, resizedHeight))
	draw.CatmullRom.Scale(dst, dst.Rect, img, img.Bounds(), draw.Over, nil)
	outFile, err := os.Create(outPath)
	if err != nil {
		return 0, 0, fmt.Errorf("error creating output file: %v", err)
	}
	defer outFile.Close()
	if err := avif.Encode(outFile, dst, avif.EncodeOptions{Speed: 10, Quality: 80}); err != nil {
		return 0, 0, fmt.Errorf("error encoding output to AVIF: %v", err)
	}
	fmt.Println(srcPath, "->", outPath)
	return resizedWidth, resizedHeight, nil
}
