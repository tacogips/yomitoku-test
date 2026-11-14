
## to dev
```
nix develop
poetry install
poetry shell
```



### result
(I couldn't get cuda work with nix flake on linux (not nixos, manjaro))

```shell
± just run-all
poetry run  do_ocr
-- cuda is NOT available --
2024-11-29 12:36:01,466 - yomitoku.base - INFO - Initialize TextDetector
2024-11-29 12:36:02,198 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:36:02,200 - yomitoku.base - INFO - Initialize TextRecognizer
2024-11-29 12:36:03,411 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:36:06,904 - yomitoku.base - INFO - TextDetector __call__ elapsed_time: 3.4473941326141357
2024-11-29 12:36:58,077 - yomitoku.utils.visualizer - WARNING - libraqm is not installed. Vertical text rendering is not supported. Rendering horizontally instead.
2024-11-29 12:36:58,226 - yomitoku.base - INFO - TextRecognizer __call__ elapsed_time: 51.32133173942566
2024-11-29 12:36:58,249 - yomitoku.base - INFO - Initialize TextDetector
2024-11-29 12:36:58,916 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:36:58,918 - yomitoku.base - INFO - Initialize TextRecognizer
2024-11-29 12:37:00,231 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:00,234 - yomitoku.base - INFO - Initialize LayoutParser
2024-11-29 12:37:01,026 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:01,031 - yomitoku.base - INFO - Initialize TableStructureRecognizer
2024-11-29 12:37:01,824 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:03,805 - yomitoku.base - INFO - LayoutParser __call__ elapsed_time: 1.9740869998931885
2024-11-29 12:37:05,002 - yomitoku.base - INFO - TextDetector __call__ elapsed_time: 3.1729536056518555
2024-11-29 12:37:05,002 - yomitoku.base - INFO - TextDetector wrapper elapsed_time: 3.1730639934539795
2024-11-29 12:37:05,403 - yomitoku.base - INFO - TableStructureRecognizer __call__ elapsed_time: 1.5980122089385986
2024-11-29 12:37:49,898 - yomitoku.utils.visualizer - WARNING - libraqm is not installed. Vertical text rendering is not supported. Rendering horizontally instead.
2024-11-29 12:37:50,042 - yomitoku.base - INFO - TextRecognizer __call__ elapsed_time: 45.03962802886963
2024-11-29 12:37:50,042 - yomitoku.base - INFO - TextRecognizer wrapper elapsed_time: 45.03972506523132
poetry run parse_img
-- cuda is NOT available --
2024-11-29 12:37:53,336 - yomitoku.base - INFO - Initialize TextDetector
2024-11-29 12:37:54,001 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:54,003 - yomitoku.base - INFO - Initialize TextRecognizer
2024-11-29 12:37:54,931 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:55,013 - yomitoku.base - INFO - Initialize TextDetector
2024-11-29 12:37:55,680 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:55,682 - yomitoku.base - INFO - Initialize TextRecognizer
2024-11-29 12:37:56,643 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:56,648 - yomitoku.base - INFO - Initialize LayoutParser
2024-11-29 12:37:57,437 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:37:57,441 - yomitoku.base - INFO - Initialize TableStructureRecognizer
2024-11-29 12:37:58,155 - yomitoku.base - WARNING - CUDA is not available. Use CPU instead.
2024-11-29 12:38:00,122 - yomitoku.base - INFO - LayoutParser __call__ elapsed_time: 1.9591374397277832
2024-11-29 12:38:01,508 - yomitoku.base - INFO - TextDetector __call__ elapsed_time: 3.347160577774048
2024-11-29 12:38:01,508 - yomitoku.base - INFO - TextDetector wrapper elapsed_time: 3.3472816944122314
2024-11-29 12:38:01,896 - yomitoku.base - INFO - TableStructureRecognizer __call__ elapsed_time: 1.7735166549682617
2024-11-29 12:38:43,545 - yomitoku.utils.visualizer - WARNING - libraqm is not installed. Vertical text rendering is not supported. Rendering horizontally instead.
2024-11-29 12:38:43,707 - yomitoku.base - INFO - TextRecognizer __call__ elapsed_time: 42.19883966445923
2024-11-29 12:38:43,707 - yomitoku.base - INFO - TextRecognizer wrapper elapsed_time: 42.19894003868103
```
