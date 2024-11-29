import cv2
import torch


from yomitoku import DocumentAnalyzer
from yomitoku import OCR
from yomitoku.data.functions import load_pdf, load_image


def do_ocr():

    if torch.cuda.is_available():
        print("-- cuda is AVAILABLE: ", torch.cuda.get_device_name(0), " --")
    else:
        print("-- cuda is NOT available --")

    ocr = OCR(
        configs={"text_detector": {}, "text_recognizer": {}},
        visualize=True,
        device="cuda",
    )
    imgs = load_pdf("pdf_files/japanese_corp_tax.pdf")
    for i, img in enumerate(imgs):
        results, ocr_vis = ocr(img)

        results.to_json(f"output/from_pdf_{i}.json")
        cv2.imwrite(f"output/from_pdf_ocr_{i}.jpg", ocr_vis)

        analyzer = DocumentAnalyzer(configs={}, visualize=True, device="cuda")
        analyze_results, ocr_vis, layout_vis = analyzer(img)
        analyze_results.to_html(f"output/from_pdf_ocr_{i}.html")
        analyze_results.to_markdown(f"output/from_pdf_ocr_{i}.md")


def parse_img():
    if torch.cuda.is_available():
        print("-- cuda is AVAILABLE: ", torch.cuda.get_device_name(0), " --")
    else:
        print("-- cuda is NOT available --")

    img = load_image("pdf_files/image_magick_japanese_corp_tax.pdf.jpg")
    analyzer = DocumentAnalyzer(configs={}, visualize=True, device="cuda")
    results, ocr_vis, layout_vis = analyzer(img)

    results.to_json(f"output/from_image.json")
    results.to_html(f"output/from_image.html")
    results.to_markdown(f"output/from_image.md")
    cv2.imwrite(f"output/from_image_ocr.jpg", ocr_vis)
