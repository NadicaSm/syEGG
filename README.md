# syEGG
This repository contains GNU Octave code for the paper titled "[Data Augmentation for Generating Synthetic Electrogastrogram Time Series](https://arxiv.org/pdf/2303.02408.pdf)" authored by Nadica Miljković (ORCiD: [0000-0002-3933-6076](https://orcid.org/0000-0002-3933-6076)), Nikola Milenić (ORCiD: [0009-0004-7794-4795](https://orcid.org/0009-0004-7794-4795)), Nenad B. Popović (ORCiD: [0000-0002-5221-1446](https://orcid.org/0000-0002-5221-1446)), and Jaka Sodnik (ORCiD: [0000-0002-8915-9493](https://orcid.org/0000-0002-8915-9493))

## GitHub repository contents
This repository contains both sample data and [GNU Octave code](https://octave.org/), as well as [README.md](https://github.com/NadicaSm/syEGG/blob/main/README.md) and [license](https://github.com/NadicaSm/syEGG/blob/main/LICENSE) files.

### Code
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).

Please, report any bugs to the Authors listed in the Contacts.

The repository contains the following code:
1) [syEGG.m](https://github.com/NadicaSm/syEGG/blob/main/syEGG.m) - software code (GNU Octave function) that generates synthetic electrogastrogram (EGG) timeseries based on method described in [[2](https://arxiv.org/pdf/2303.02408.pdf)] that is derived from parameters calculated on data available in [[3](https://doi.org/10.1515/bmt-2017-0218)-[4](https://doi.org/10.5281/zenodo.3730617)]
2) [syEGG_VR.m](https://github.com/NadicaSm/syEGG/blob/main/syEGG_VR.m) - software code (GNU Octave function) that generates altered EGG timeseries in the presence of simulator sickness, the method is fully described in [[2](https://arxiv.org/pdf/2303.02408.pdf)]
3) [paper_figs.m](https://github.com/NadicaSm/syEGG/blob/main/paper_figs.m) - software code (GNU Octave code) for reproducibility of figures presented in [[2](https://arxiv.org/pdf/2303.02408.pdf)], it uses syEGG.m, syEGG_VR.m, and ID18_postprandial.txt
4) [stepAnalysis.m](https://github.com/NadicaSm/syEGG/blob/main/stepAnalysis.m) - software code (GNU Octave code) for extensive analysis of applied Butterworth filter in [[2](https://arxiv.org/pdf/2303.02408.pdf)]
5) [automaticDetectionBA.m](https://github.com/NadicaSm/syEGG/blob/main/automaticDetectionBA.m) - software code (GNU Octave code) examination of breathing artifact for [[2](https://arxiv.org/pdf/2303.02408.pdf)], it uses data from [[3](https://doi.org/10.1515/bmt-2017-0218)-[4](https://doi.org/10.5281/zenodo.3730617)]

### Data
1) [ID18_postprandial.txt](https://github.com/NadicaSm/syEGG/blob/main/ID18_postprandial.txt) - sample data from the EGG database [[3](https://doi.org/10.1515/bmt-2017-0218)-[4](https://doi.org/10.5281/zenodo.3730617)] that is used for producing figures by paper_figs.m software code (The data is licensed under [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/legalcode))

## Contacts
N. Milenić ([milenicnikola@gmail.com](mailto:milenicnikola@gmail.com)) or N. Miljković (e-mail: [nadica.miljkovic@etf.bg.ac.rs](mailto:nadica.miljkovic@etf.bg.ac.rs)).

## Funding
Nadica Miljković acknowledges the support from the grant No. 451-03-65/2024-03/200103 funded by the Ministry of Science, Technological Development and Innovation, Republic of Serbia. Jaka Sodnik acknowledges the support from Slovenian Research Agency under grant No. P2-0246. The Funders were not involved in the study design, collection, analysis, and interpretation of data; in the manuscript preparation; and in the decision to submit the manuscript.

## Acknowledgement
We kindly thank Prof. Sašo Tomažič from Faculty of Electrical Engineering, University of Ljubljana for his valuable advises on signal processing methods.

## How to cite this repository?
If you find provided code and signals useful for your own research and teaching class, please cite the following references:
1) Miljković, N., Milenić, N., Popović, N.B., and Sodnik, J., 2023. [NadicaSm/syEGG](https://github.com/NadicaSm/): v1 (Version v1). Version v1. [Software code] Zenodo. [https://doi.org/10.5281/zenodo.7698446](https://doi.org/10.5281/zenodo.7698446)
2) Miljković, N., Milenić, N., Popović, N.B., and Sodnik, J., 2023. Data Augmentation for Generating Synthetic Electrogastrogram Time Series. Preprint. [http://arxiv.org/abs/2303.02408](http://arxiv.org/abs/2303.02408)
3) Popović, N.B., Miljković, N. and Popović, M.B., 2019. Simple gastric motility assessment method with a single-channel electrogastrogram. Biomedical Engineering/Biomedizinische Technik, 64(2), pp.177-185, doi: [https://doi.org/10.1515/bmt-2017-0218](https://doi.org/10.1515/bmt-2017-0218).
4) Popović, N.B., Miljković, N. and Popović, M.B., 2020. Three-channel surface electrogastrogram (EGG) dataset recorded during fasting and post-prandial states in 20 healthy individuals [Data set]. Zenodo, doi: [https://doi.org/10.5281/zenodo.3730617](https://doi.org/10.5281/zenodo.3730617).
