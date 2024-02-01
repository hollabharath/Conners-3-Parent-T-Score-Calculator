# Conners 3 Parent T-Score Calculations

This R script is designed to calculate T-scores from raw data based on the Conners 3 Parent assessment. It processes input CSV files containing specific assessment data and generates output files with calculated T-scores.

## Features

- Checks for necessary input data format and validity.
- Recodes specific item responses according to scoring guidelines.
- Calculates raw scores for designated domains.
- Generates T-scores using age and sex-specific norms.
- Outputs a CSV file with both raw and T-scores.

## Requirements

- R environment (version 3.6.0 or later recommended).
- `dplyr` package installed.

## Installation

Ensure you have R installed on your system. You can download it from [CRAN](https://cran.r-project.org/).

To install the `dplyr` package, run the following command in your R console:

```
install.packages("dplyr")
```
## Usage

To use this script, navigate to the directory containing the script and execute it from the command line:
```
Rscript Conners3PTScoreCalculator.R path_to_input_csv_file
```
### Input File Format

The input CSV file should have the following columns:

- `Age`: Integer values in the range of 6 to 18.
- `Sex`: Values should be 'F', 'female', 'M', or 'male'.
- 108 columns starting with `con3_p_` (e.g., `con3_p_1`, `con3_p_2`, ..., `con3_p_108`) with integer values in the range of 0 to 3.

### Output

The script generates an output file in the same directory as the input file, named with the original file name followed by '-R+T.csv'. This file will include both the raw scores (`_raw`) and the calculated T-scores (`_t`).

### Acknowledgements
This script is developed to assist with the calculation of T-scores based on the scoring guidelines of the Conners 3 Parent assessment. It is designed for researchers, clinicians, and professionals who have legal access to the Conners 3 assessment materials.

### Conners-3-P-T-Scoring-Grid
This script relies on the Conners 3 Parent assessment scoring grids for accurate T-score calculation. Due to copyright restrictions, the electronic versions of these scoring grids are not included in this repository. If you have legally obtained the Conners assessments from official sources and need assistance integrating the scoring grids with this script, please feel free to contact me.

By using this script, you acknowledge that you have obtained the necessary permissions to use the Conners assessment materials and that you will use them responsibly and ethically in accordance with all legal requirements.
