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

There are 3 different subdirectories for Graph A in `yeast_sv/graphs`:
- `yeast_sv/graphs/constructunion_all` - Integrate variants from all strains into graph
- `yeast_sv/graphs/constructunion_twoout` - Integrate variants from only 9 of the strains into the graph (excluding Y12 and N44)
- `yeast_sv/graphs/constructunion_conly` - Integrate variants from only S. cerevisiae strains into the graph

For the first graph, run:
```
cd yeast_sv/graphs/constructunion_all
snakemake
```

This will create Graph A using S288C as reference strain and the high-sensitivity variant callset produced before. 

As a result `yeast_sv/graphs/constructunion_*/mappings` will contain the sorted GAM alignments of the Illumina reads against the graph.


## Run cactus

First, install toil in a virtual environment:
```
pip install virtualenv
virtualenv cactus_env
source cactus_env/bin/activate
pip install --upgrade toil
```

Like for Graph A, there are 3 different flavors of Graph B: `all`, `twoout` and `conly`. To create either of them, now follow the steps in `yeast_sv/cactus/all/aws_commands.sh`, `yeast_sv/cactus/twoout/aws_commands.sh` or `yeast_sv/cactus/conly/aws_commands.sh`.


## Create, index and map Illumina reads to Graph B

```
cd yeast_sv/graphs/cactus_all
snakemake
```

This will create Graph B from the cactus alignments produced in the previous step. Do likewise for the `twoout` and `conly` graphs.

As a result `yeast_sv/graphs/cactus_*/mappings` will contain the sorted GAM alignments of the Illumina reads against the graph.


## Genotype SVs on Graph A and Graph B

First, install toil in a virtual environment:
```
virtualenv toilvenv
source toilvenv/bin/activate
pip install toil[aws,mesos]==3.18.0
pip install toil-vg
```

For Graph A, follow the steps in `yeast_sv/vg_call/graphA_aws_commands.sh`. It contains commands for the `all` graph but can be easily modified for the `twoout` and `conly` graphs.
For Graph B, follow the steps in `yeast_sv/vg_call/graphB_aws_commands.sh`.

