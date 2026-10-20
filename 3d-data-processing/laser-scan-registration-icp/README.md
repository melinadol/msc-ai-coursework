# Laser-scan registration and meshing with ICP (MeshLab)

Course **3D Data Processing and Visualization**. Stage 1 delivery: registered and triangulated point cloud of a monument from terrestrial laser scans (FARO).

- Cleaning each scan of noise and of points outside the object of interest.
- Normal estimation for every point from its neighbourhood.
- Pairwise **ICP** alignment in MeshLab using the overlaps between scans, then global alignment of all scans into one coordinate system (a rigid-body transformation: translation X0, Y0, Z0 and rotations ω, φ, κ, scale 1:1).
- Mesh-to-mesh alignment of the two views: average error dropped from 12.25 to **0.0045** (median 0.005, 90 % < 0.005), with a global error bound of 0.001.
- Triangulation into a 3D mesh of the monument.

Report with screenshots (in Greek): [`report_3d_meshes_icp.pdf`](report_3d_meshes_icp.pdf).
