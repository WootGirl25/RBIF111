SeSAMe: reducing artifactual detection of DNA methylation by Infinium BeadChips in genomic deletions

### Summary
The article introduces SeSAMe, an R package designed to address artifacts in DNA methylation measurements from Illumina HumanMethylation450 and MethylationEPIC arrays. These artifacts arise from failed hybridization due to genomic deletions or hyperpolymorphism, leading to spurious intermediate methylation signals that can confound epigenome-wide association studies (EWAS) and methylation-quantitative trait loci (meQTL) analyses.

SeSAMe implements a novel detection P-value method, pOOBAH (P-value with out-of-band array hybridization), which effectively masks problematic probes. Key features and findings include:
- **Artifact Reduction**: SeSAMe reduces false-positive methylation signals caused by genomic deletions and cross-hybridization.
- **Improved Consistency**: It enhances consistency between HM450, EPIC, and whole-genome bisulfite sequencing (WGBS) platforms.
- **Batch Effect Mitigation**: SeSAMe reduces technical variation (e.g., batch effects) while retaining biological variation.
- **Cross-Platform Integration**: Facilitates combined analyses of HM450 and EPIC data, addressing the need to integrate legacy and new datasets.

### Key Results
1. **Detection of Artifacts**: SeSAMe identifies and masks probes affected by germline and somatic deletions, hyperpolymorphic regions (e.g., HLA loci), and low signal intensities.
2. **Improved Data Quality**: It reduces spurious intermediate methylation signals, particularly in regions like tumor suppressor genes (e.g., CDKN2A, RB1).
3. **Enhanced Cross-Platform Correlation**: SeSAMe improves agreement between HM450 and EPIC platforms, as well as with WGBS data.
4. **Technical Variation Reduction**: By addressing non-detection artifacts, SeSAMe minimizes batch effects and improves clustering of biological replicates.

### Applications
SeSAMe is a lightweight, modular tool for preprocessing DNA methylation data, suitable for large-scale studies. It is particularly useful for:
- EWAS and meQTL studies
- Cancer research involving copy number alterations
- Cross-platform data integration

### Conclusion
SeSAMe provides a robust solution to reduce technical artifacts in DNA methylation data, improving the reliability of downstream analyses and enabling better integration of legacy and modern datasets.