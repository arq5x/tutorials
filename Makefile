all:
	pandoc --toc --css template/template.css --template template/template.html -s -S gemini.md -o gemini.html
	pandoc --css templatetemplate.css --template template/template.html -s -S gemini.solution.md -o gemini.solution.html
	pandoc --toc --css template/template.css --template template/template.html -s -S samtools.md -o samtools.html
	pandoc --toc --css template/template.css --template template/template.html -s -S bedtools.md -o bedtools.html

clean:
	rm *.html