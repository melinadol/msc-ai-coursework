# LVQ2 and LFM classifiers (MATLAB)

From-scratch MATLAB implementations of two prototype- and memory-based classifiers, tested on the **Iris** and **Wine** datasets.

- **LVQ2 (Learning Vector Quantization 2)** (`LVQ2.m`, `IRIS_LVQ2.m`): prototype vectors per class. For each training pattern the two nearest prototypes are found. If the nearest has the wrong class and the second-nearest has the right one, the wrong prototype is pushed away and the right one pulled closer.
- **LFM** (`LFM.m`, `iris_lfm.m`): the memory-based variant compared against LVQ2.
- Data split 70 % training / 20 % validation / 10 % test. Experiments vary the prototypes per class (ppc), the epochs and the learning rate. On Wine, the best trade-off between accuracy and time was ppc = 1 for LVQ2 and ppc = 2 for LFM, with 10 epochs and a learning rate of 0.01.

Report (in Greek): [`report_lvq2_lfm.pdf`](report_lvq2_lfm.pdf). The data files (`iris.txt`, `WINE.TXT`) are not included; both are the standard UCI datasets.
