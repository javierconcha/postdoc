#!/bin/sh
pdflatex -draftmode -shell-escape  -interaction=batchmode $1.tex
bibtex $1.aux
#makeglossaries 2015_RSofEnv_paper
pdflatex -draftmode -shell-escape -interaction=batchmode $1.tex
pdflatex  -shell-escape $1.tex
open $1.pdf
