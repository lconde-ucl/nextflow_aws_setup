#!/bin/bash -l


module load r/recommended
module load pandoc


# this does nto preserve the lumen theme
#pandoc AWS_doc.md -o AWS_doc.html

R --vanilla  -e "rmarkdown::render('AWS_doc.Rmd',output_file='AWS_doc.html')"

