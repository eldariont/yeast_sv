# yeast_sv

This repo contains my snakemake pipelines and other scripts for SV genotyping using vgteam/vg on 12 yeast strains. Primarily, I compared the SV genotyping performance of two different vg graphs:

- **Graph A**: Created with `vg construct` using S288C as reference strain and VCFs with SVs from Assemblytics (Nattestad et al.), AsmVar (Huang et al.) and paftools (Li) as variants
- **Graph B**: Created from multiple genome alignment of all 12 strains using [cactus](https://github.com/ComparativeGenomicsToolkit/cactus) and [hal2vg](https://github.com/ComparativeGenomicsToolkit/hal2vg)

Here is what I did:

## Prepare yeast assemblies and call SVs relative to the reference strain S288C

```
git clone https://github.com/eldariont/yeast_sv.git
cd yeast_sv/assemblies
snakemake
```

This will clone this repo including the contained PacBio assemblies from the [
Yeast Population Reference Panel (YPRP)](https://yjx1217.github.io/Yeast_PacBio_2016/welcome/). Subsequently, it will run 3 SV calling pipelines on the 11 non-reference strains:
- [Minimap2](https://github.com/lh3/minimap2) + paftools call
- LAST + [AsmVar](https://github.com/bioinformatics-centre/AsmVar)
- nucmer + [Assemblytics](https://github.com/marianattestad/assemblytics)

Because the resulting callset differ considerably two merged callsets are produced:
- High-sensitivy callset = union of all 3 callsets
- High-confidence callset = all variants supported by at least two of the callers

## Download Illumina reads for the same 12 strains

```
cd yeast_sv/illumina_reads
snakemake
```

## Create, index and map Illumina reads to Graph A

```
cd yeast_sv/graphs/constructunion_all
snakemake
```

This will create Graph A using S288C as reference strain and the high-sensitivity variant callset produced before. There are 3 different subdirectories for Graph A in `yeast_sv/graphs`:
- `yeast_sv/graphs/constructunion_all` - Integrate variants from all strains into graph
- `yeast_sv/graphs/constructunion_twoout` - Integrate variants from only 9 of the strains into the graph (excluding Y12 and N44)
- `yeast_sv/graphs/constructunion_all` - Integrate variants from only S. cerevisiae strains into the graph

As a result `yeast_sv/graphs/constructunion_*/mappings` will contain the sorted GAM alignments of the Illumina reads against the graph.



