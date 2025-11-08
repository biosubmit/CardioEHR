# CardioEHR

EHR data processing and analysis project.

This project contains Python scripts for privacy-preserving processing of EHR data and R scripts for reproducible analysis and visualization.

## Data

The original EHR data are hosted on the OMIX platform under controlled access (accession number: OMIX010546). Please submit a formal request to access the dataset.

## Quick Start

1. **Clone Repo:**

   ```bash
   git clone git@github.com:biosubmit/CardioEHR.git
   cd CardioEHR
   ```
2. **Install Dependencies:**

   ```bash
   uv sync
   ```
3. **Process Data:**

   ```bash
   uv run split_lab_test.py
   ```
4. **Run Analysis:**

   ```bash
   Rscript analysis_update.r
   ```

## License

MIT License.
