TEX_FILE_NAME = otimizacao
OUPUT_FILE_NAME = otimizacao

all: $(OUTPUT_FILE_NAME).pdf

$(OUTPUT_FILE_NAME).pdf : $(TEX_FILE_NAME).tex
	pdflatex $(TEX_FILE_NAME).tex
	pdflatex $(TEX_FILE_NAME).tex
	bibtex	$(TEX_FILE_NAME).aux
	pdflatex $(TEX_FILE_NAME).tex
	pdflatex $(TEX_FILE_NAME).tex

clean:
	rm -f $(TEX_FILE_NAME).aux $(TEX_FILE_NAME).bbl $(TEX_FILE_NAME).blg $(TEX_FILE_NAME).lof $(TEX_FILE_NAME).log $(TEX_FILE_NAME).maf $(TEX_FILE_NAME).mtc* $(TEX_FILE_NAME).out $(TEX_FILE_NAME).toc $(TEX_FILE_NAME).nlo

vclean: clean
	rm -f $(OUPUT_FILE_NAME).pdf

