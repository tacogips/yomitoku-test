
run-ocr:
	poetry run  do_ocr

run-img:
	poetry run parse_img

run-all: run-ocr run-img

pdf-to-image:
	magick -density 400 -quality 100 pdf_files/japanese_corp_tax.pdf	pdf_files/image_magick_japanese_corp_tax.pdf.jpg

shell:
	poetry shell
