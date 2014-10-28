NBS := $(wildcard [0-9]*.ipynb)

all: $(NBS:%.ipynb=%-slides.pdf) ncso.pdf

%.tex: %.ipynb
	nb2tex -n $^

%-slides.pdf: %.ipynb
	nb2tex -b $^
	pdflatex -file-line-error -interaction=batchmode $(^:%.ipynb=%-slides.tex) || true
	egrep ':[0-9]+:' $(^:%.ipynb=%-slides.log) | uniq

ncso.pdf: ncso.tex $(NBS:%.ipynb=%.tex)
	pdflatex -file-line-error -interaction=batchmode ncso.tex || true
	pdflatex -file-line-error -interaction=batchmode ncso.tex || true
	egrep ':[0-9]+:' ncso.log | uniq

clean:
	rm -f $(NBS:%.ipynb=%.tex)
	rm -f $(NBS:%.ipynb=%-slides.tex)
	rm -f $(NBS:%.ipynb=%-slides.pdf)
	rm -f *.log *.nav *.snm *.toc *.vrb *.aux *.out

public: all
	mkindex > index.html
	rsync -v index.html ncso.pdf $(NBS) $(NBS:%.ipynb=%-slides.pdf) iupr1.cs.uni-kl.de:public_html/ncso

