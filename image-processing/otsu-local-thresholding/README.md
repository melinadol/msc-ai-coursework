# Otsu and local thresholding (MATLAB, Dec 2022)

Course **Image Processing & Analysis**. Image binarisation implemented from scratch:

- **(a) Otsu's method** (`A_otsu_sb.m`): the grey-level histogram (256 bins) is built, and for every candidate threshold 1 ≤ t ≤ 254 the within-class variance of the two classes is computed. The threshold that minimises it, which is the same as maximising the between-class variance, is chosen.
- **(b) Local (adaptive) thresholding** (`B_local_katwfliosi.m`): a separate threshold for each pixel from the **mean** or the **median** of an r × c window around it, minus a constant C. This handles uneven illumination and locally low contrast, which a single global threshold cannot. The effect of the window size is studied.

Tested on standard images (sudoku, cameraman, coins, lena, …). Report with all results (in Greek): [`report_otsu_local_thresholding.pdf`](report_otsu_local_thresholding.pdf). The test images are not included.
