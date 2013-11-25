% GEMINI Tutorial
% Aaron Quinlan
% November 19, 2013


Synopsis
========

**What is GEMINI?** GEMINI (GEnome MINIng) is designed to be a flexible framework for exploring genetic variation in the context of the wealth of genome annotations available for the human genome. By placing genetic variants, sample genotypes, and useful genome annotations into an integrated database framework, GEMINI provides a simple, flexible, yet very powerful system for exploring genetic variation for for disease and population genetics.

Using the GEMINI framework begins by loading a VCF file into a database. Each variant is automatically annotated by comparing it to several genome annotations from source such as ENCODE tracks, UCSC tracks, OMIM, dbSNP, KEGG, and HPRD. All of this information is stored in portable SQLite database that allows one to explore and interpret both coding and non-coding variation using “off-the-shelf” tools or an enhanced SQL engine.

**The dataset**. This tutorial is intended to give you a sense of the types of analyses you can do with GEMINI. We will be working with a dataset generated from exome sequencing of 4 families (mother, father, and child in each family). The resulting sequencing data have been aligned with BWA-MEM and
variants have been called with FreeBayes. As a result, we have a VCF file with 12 individuals. We will be using GEMINI to explore the genetic variation that is present in these 12 individuals. 


Please refer to the GEMINI [documentation](http://gemini.readthedocs.org/en/latest/) for further details. In particular, the names and descriptions of the annotations that you have at your disposal in the [variants table](http://gemini.readthedocs.org/en/latest/content/database_schema.html#the-variants-table) will be particularly useful. In addition, the list of [built-in analysis tools](http://gemini.readthedocs.org/en/latest/content/tools.html) is also a very useful reference.


\


SQL Overview
============
In order to use GEMINI to its full potential, one needs to be familiar
with SQL (Structured Query Language), which is a powerful and expressive
language for exploring data in databases.

- [SQL Basics](http://sqlzoo.net/wiki/SELECT_basics)
- [Nobel Prize examples](http://sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial)
- [Counting](http://sqlzoo.net/wiki/SUM_and_COUNT)

Now, let's explore the GEMINI documentation to get a better understanding
of the GEMINI database.
http://gemini.readthedocs.org/en/latest/content/database_schema.html


\


What are VCF and PED files?
================================
Please refer to the following resources.

- [VCF](http://www.1000genomes.org/wiki/Analysis/Variant%20Call%20Format/vcf-variant-call-format-version-41)
- [PED](http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml#ped)


\


Installing GEMINI.
================================
If you don't already have GEMINI installed, please follow the automated installation [instructions](http://gemini.readthedocs.org/en/latest/content/installation.html#automated-installation). If you simply want to install the GEMINI software for exloring *existing* GEMINI databases, you may choose to use the `--nodata` option when running the automated installer.


\



Loading the VCF file into GEMINI
================================

**NOTE**: **this step has been done for you.**

The first step is to load one's VCF file into a GEMINI database. In so doing,
each variant in the VCF is automatically annotated with information from the
1000 Genomes Project, ESP, ENCODE, KEGG, ClinVar, etc. This is a fairly slow
process (e.g. about 15-20 minutes for whole-exome datasets). Therefore, this
step has been done for you. This VCF file was pre-annotated by VEP using the
instructions provided [here](http://gemini.readthedocs.org/en/latest/content/functional_annotation.html#stepwise-installation-and-usage-of-vep).

    # gemini load -v gemini.vcf -p gemini.ped -t VEP --cores 4 gemini.vcf.db


\


First, make a GEMINI sandbox directory
===============================================

    mkdir gemini-sandbox
    cd gemini-sandbox

\


Download the pre-created GEMINI database
========================================

Just as a warning, this file is roughly 1.5 Gb.

    curl -O http://quinlanlab.cs.virginia.edu/gemini.vcf.db

\


Now, let's upgrade GEMINI
===========================

    gemini update


\


Using GEMINI
============

\


Getting Help
------------

    gemini --help

\


What version?
-------------

    gemini --version

\




Basic data exploration
======================
The following exercises will work you through some basic examples of how to use
GEMINI for basic exploration of the genetic variation that is in your database.


\


Beginner
--------

How many variants are SNPs?
    
    gemini query -q "select count(*) from variants where type = 'snp' " gemini.vcf.db

How many variants are INDELs?

    gemini query -q "select count(*) from variants where type = 'indel' " gemini.vcf.db

How many variants are exonic? Not exonic?

    gemini query -q "select count(*) from variants where is_exonic = 1" gemini.vcf.db

    gemini query -q "select count(*) from variants where is_exonic = 0" gemini.vcf.db

How many variants are coding? Not coding?

    gemini query -q "select count(*) from variants where is_coding = 1" gemini.vcf.db

    gemini query -q "select count(*) from variants where is_coding = 0" gemini.vcf.db

How many variants are novel with respect to dbSNP?

    gemini query -q "select count(*) from variants where in_dbsnp = 0" gemini.vcf.db

How many variants are non-synonymous (missense)?

    gemini query -q "select count(*) from variants where impact = 'non_syn_coding'" gemini.vcf.db


\


Intermediate
------------

How many variants are there for each type of variant impact (e.g., nonsynonymous, stop-gain, etc.)?

    gemini query -q "select impact, count(*) from variants group by impact" gemini.vcf.db

Let's sort the results in descending order of frequency.

    gemini query -q "select impact, count(*) from variants group by impact" gemini.vcf.db \
    | sort -k2,2nr

How many rare (< .1% allele frequency), loss-of-function variants are there?

    gemini query -q "select count(*) from variants \
                     where aaf_1kg_all < 0.001 \
                     and is_lof = 1" \
           gemini.vcf.db 

How many non-coding variants overlap ENCODE hypersensitivity sites in _any_ cell type?

    gemini query -q "select count(*) from variants \
                     where is_coding = 0 \
                     and encode_dnaseI_cell_count >= 1" \
           gemini.vcf.db 

How many non-coding variants overlap ENCODE hypersensitivity sites in 20 or more cell types?

    gemini query -q "select count(*) from variants \
                     where is_coding = 0 \
                     and encode_dnaseI_cell_count >= 20" \
           gemini.vcf.db

What are these variants (notice we are not counting anymore)?

    gemini query -q "select chrom, start, end, ref, alt, \
                            encode_dnaseI_cell_count from variants \
                     where is_coding = 0 \
                     and encode_dnaseI_cell_count >= 20" \
           gemini.vcf.db

Which cell types?

    gemini query -q "select chrom, start, end, ref, alt, \
                            encode_dnaseI_cell_count, encode_dnaseI_cell_list from variants \
                     where is_coding = 0 \
                     and encode_dnaseI_cell_count >= 20" \
           gemini.vcf.db

Which of these variants that overlap DNase I hypersensitivity sites in at least 20 cells
are also shown to be a binding site for your favorite transcription factor (e.g., Pol2)?

    gemini query -q "select chrom, start, end, ref, alt, \
                            encode_tfbs from variants \
                     where is_coding = 0 \
                     and encode_dnaseI_cell_count >= 20 \
                     and encode_tfbs like '%Pol2%' " \
           gemini.vcf.db


\


Advanced 
----------

In other words, you are on your own figure out the query. I will show the answers later...


**1. Which variants are private (as a heterozygote) to a single sample?** *Hint:* see [this](http://gemini.readthedocs.org/en/latest/content/database_schema.html#variant-and-popgen-info) documentation page.

    gemini query -q "select chrom, start, end, ref, alt, \
                            num_het, num_hom_alt \
                     from variants \
                     where num_het = 1 and num_hom_alt = 0" \
           gemini.vcf.db 


**2. For which variants is sample "1_kid" heterozygous for the alternate allele?** *Hint:* see [this](http://gemini.readthedocs.org/en/latest/content/querying.html#gt-filter-filtering-on-genotypes) documentation page.


    gemini query -q "select chrom, start, end, ref, alt, gts.1_kid \
                     from variants" \
           --gt-filter "gt_types.1_kid == HET" \
           gemini.vcf.db 

**3. Write a query that identifies candidate de novo mutations in family number 1** *Hint:* see [this](http://gemini.readthedocs.org/en/latest/content/querying.html#gt-filter-filtering-on-genotypes) documentation page.

    gemini query -q "select chrom, start, end, ref, alt, \
                            gts.1_kid, gts.1_dad, gts.1_mom \
                     from variants" \
           --gt-filter "gt_types.1_kid == HET and \
                        gt_types.1_dad == HOM_REF and \
                        gt_types.1_mom == HOM_REF" \
           gemini.vcf.db 


``Aside:`` How many real de novo variants would we expect in an exome?

**4.As an improvement to question #3, require that the genotype for each member of the family
is supported by at least 20 aligned sequences. Why does this matter?** *Hint:* see [this](http://gemini.readthedocs.org/en/latest/content/database_schema.html#genotype-information) documentation page.

    gemini query -q "select chrom, start, end, ref, alt, \
                            gts.1_kid, gts.1_dad, gts.1_mom, \
                            gt_depths.1_kid, gt_depths.1_dad, gt_depths.1_mom
                     from variants" \
           --gt-filter "gt_types.1_kid == HET and \
                        gt_types.1_dad == HOM_REF and \
                        gt_types.1_mom == HOM_REF and \
                        gt_depths.1_kid >= 20 and \
                        gt_depths.1_mom >= 20 and \
                        gt_depths.1_dad >= 20"  \
           gemini.vcf.db 

**5. Okay, that's better. But are there any that appear to be detrimental to the protein?** *Hint:* the values for the `impact_severity` column are 'LOW', 'MEDIUM', 'HIGH'.


    gemini query -q "select chrom, start, end, ref, alt, impact, \
                            gts.1_kid, gts.1_dad, gts.1_mom, \
                            gt_depths.1_kid, gt_depths.1_dad, gt_depths.1_mom
                     from variants \
                     where impact_severity != 'LOW'" \
           --gt-filter "gt_types.1_kid == HET and \
                        gt_types.1_dad == HOM_REF and \
                        gt_types.1_mom == HOM_REF and \
                        gt_depths.1_kid >= 20 and \
                        gt_depths.1_mom >= 20 and \
                        gt_depths.1_dad >= 20"  \
           gemini.vcf.db 


**6. What does PolyPhen or SIFT say about these variants?** *Hint:* see [this](http://gemini.readthedocs.org/en/latest/content/database_schema.html#gene-information) documentation page.


    gemini query -q "select chrom, start, end, ref, alt, impact, polyphen_pred, sift_pred, gene, clinvar_disease_name, \
                            gts.1_kid, gts.1_dad, gts.1_mom, \
                            gt_depths.1_kid, gt_depths.1_dad, gt_depths.1_mom \
                     from variants \
                     where impact_severity != 'LOW' " \
           --gt-filter "gt_types.1_kid == HET and \
                        gt_types.1_dad == HOM_REF and \
                        gt_types.1_mom == HOM_REF and \
                        gt_depths.1_kid >= 20 and \
                        gt_depths.1_mom >= 20 and \
                        gt_depths.1_dad >= 20"  \
           gemini.vcf.db 



\


Built-in tools
==================

GEMINI has several built-in tools for automated analyses. The [documentation](http://gemini.readthedocs.org/en/latest/content/tools.html) covers these tools and we will walk through them in class.


Testing for recessive variants.
===============================

As an example of the built-in tools that GEMINI provides, we will look for variants that meet an [autosomal recessive](http://gemini.readthedocs.org/en/latest/content/tools.html#autosomal-recessive-find-variants-meeting-an-autosomal-recessive-model) inheritance model.

By default, this tool will report all variants that meet this model, regardless of their functional impact. We will use the `--columns` option to report a subset of the columns in the GEMINI [variants](http://gemini.readthedocs.org/en/latest/content/database_schema.html#the-variants-table) table.

    gemini autosomal_recessive \
        --columns "chrom, start, ref, alt, impact, gene" \
        gemini.vcf.db
    
Results:

    family_id   family_members  family_genotypes    family_genotype_depths  chrom   start   ref alt impact  gene
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  T/C,T/C,C/C 43,118,87   chrX    12628048    T   C       downstream  7SK
    4   4_dad(father; unaffected),4_mom(mother; unaffected),4_kid(child; affected)  GC/G,GC/G,G/G   7,5,5   chr19   58858230    GC  G       upstream    A1BG-AS1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  T/C,T/C,C/C 7,5,3   chr12   8987549 T   C   intron      A2ML1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  A/G,A/G,G/G 62,73,56    chr12   9020911 A   G       synonymous_coding   A2ML1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  C/T,C/T,T/T 18,35,15    chr12   9021255 C   T       intron  A2ML1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  C/A,C/A,A/A 18,19,12    chr12   9021524 C   A       intron  A2ML1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  T/A,T/A,A/A 3,4,5   chr12   9406033 T   A       downstream  A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/G,C/G,G/G 62,92,105   chr12   9406288 C   G   nc_ exon A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  G/A,G/A,A/A 26,42,30    chr12   9406401 G   A       intron  A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/T,C/T,T/T 14,45,44    chr12   9409128 C   T       intron  A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  A/G,A/G,G/G 1,3,1   chr12   9413606 A   G   intron      A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  A/G,A/G,G/G 8,9,8   chr12   9413683 A   G   intron      A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  TA/T,TA/T,T/T   30,26,24    chr12   9413778 TA  T       intron  A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  T/C,T/C,C/C 55,63,56    chr12   9413852 T   C   nc_ exon A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  A/G,A/G,G/G 55,73,59    chr12   9413866 A   G   nc_ exon A2MP1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  T/G,T/G,G/G 25,23,23    chr12   9413983 T   G       intron  A2MP1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  T/C,T/C,C/C 16,21,12    chr1    33777523    T   C       intron  A3GALT2
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  G/C,G/C,C/C 8,12,8  chr3    137843017   G   C   UTR_    3_prime A4GNT
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  T/C,T/C,C/C 24,21,17    chr3    137843105   T   C       synonymous_stop A4GNT
    ...


In many cases, however, we want to restrict our focus to variants that are likely to cause a loss of protein function. We can use the `--filter` option to filter the types of variants that are reported.

    gemini autosomal_recessive \
        --columns "chrom, start, ref, alt, impact, gene, is_lof" \
        --filter "is_lof=1" gemini.vcf.db
    
Results:
    
    family_id   family_members  family_genotypes    family_genotype_depths  chrom   start   ref alt impact  gene    is_lof
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  G/A,G/A,A/A 5,15,28 chr20   25281332    G   A       splice_donor    ABHD12  1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  A/AG,A/AG,AG/AG 2,3,3   chr20   25283937    A   AG      frame_shift ABHD12  1
    4   4_dad(father; unaffected),4_mom(mother; unaffected),4_kid(child; affected)  GT/G,GT/G,G/G   2,1,1   chr7    131577820   GT  G       splice_acceptor AC009518.2  1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  TC/TTTGCAG,TC/TTTGCAG,TTTGCAG/TTTGCAG   11,1,7      chr12   11187131    TC  TTTGCAG frame_shift AC018630.1  1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/A,C/A,A/A 41,87,167   chr2    240323660   C   A       stop_gain   AC062017.1  1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  C/A,C/A,A/A 136,157,42  chr2    240323660   C   A       stop_gain   AC062017.1  1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  T/TG,T/TG,TG/TG 149,181,84  chr2    240323904   T       TG  frame_shift AC062017.1  1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  A/G,A/G,G/G 98,91,90    chr7    1878376 A   G       transcript_codon_change AC110781.3  1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  C/T,C/T,T/T 60,47,50    chr21   28216065    C   T       stop_gain   ADAMTS1 1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  A/G,A/G,G/G 64,61,52    chr1    100316588   A   G       splice_acceptor AGL 1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  T/TG,T/TG,TG/TG 25,21,15    chr14   77935238    T       TG  frame_shift AHSA1   1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  AA/A,AAAC/AA,AA/AA  86,75,59    chr6    109850197       AAAC    AA,A    frame_shift AK9 1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  G/A,G/A,A/A 60,73,56    chr12   52284273    G   A       splice_donor    ANKRD33 1
    4   4_dad(father; unaffected),4_mom(mother; unaffected),4_kid(child; affected)  GGCCCCC/TGCCTCT,GGCCCCC/TGCCTCT,TGCCTCT/TGCCTCT     32,36,22    chr17   7012072 GGCCCCC TGCCTCT splice_donor    ASGR2   1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  CGG/CGA,CGG/CGA,CGA/CGA 12,21,47    chr11       76751583    CTGG    CGG,CGA frame_shift B3GNT6  1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  T/TACAG,T/TACAG,TACAG/TACAG 139,103,121 chr11       4592705 T   TACAG,TACAC frame_shift C11orf40    1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/T,C/T,T/T 54,76,147   chr15   40856988    C   T       splice_donor    C15orf57    1
    4   4_dad(father; unaffected),4_mom(mother; unaffected),4_kid(child; affected)  T/A,T/A,A/A 38,56,29    chr8    11619503    T   A       stop_gain   C8orf49 1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  T/A,T/A,A/A 111,184,344 chr19   42092814    T   A       splice_acceptor CEACAM21    1
    ...

You'll notice that some of these candidates look a bit fishy since the depth of aligned sequence in each sample is a bit low. As such, it is possible that the genotypes for these individuals at these sites are incorrect owing to the lack of sufficent sequencing depth.  We can use the `-d` option to require a minimum depth of sequence for each member.

    gemini autosomal_recessive --columns "chrom, start, ref, alt, impact, gene, is_lof" \
        --filter "is_lof=1" \
        -d 30 \
        gemini.vcf.db

Results:
   
    family_id   family_members  family_genotypes    family_genotype_depths  chrom   start   ref alt impact  gene    is_lof
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/A,C/A,A/A 41,87,167   chr2    240323660   C   A       stop_gain   AC062017.1  1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  C/A,C/A,A/A 136,157,42  chr2    240323660   C   A       stop_gain   AC062017.1  1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  T/TG,T/TG,TG/TG 149,181,84  chr2    240323904   T       TG  frame_shift AC062017.1  1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  A/G,A/G,G/G 98,91,90    chr7    1878376 A   G       transcript_codon_change AC110781.3  1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  C/T,C/T,T/T 60,47,50    chr21   28216065    C   T       stop_gain   ADAMTS1 1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  A/G,A/G,G/G 64,61,52    chr1    100316588   A   G       splice_acceptor AGL 1
    2   2_dad(father; unaffected),2_mom(mother; unaffected),2_kid(child; affected)  AA/A,AAAC/AA,AA/AA  86,75,59    chr6    109850197       AAAC    AA,A    frame_shift AK9 1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  G/A,G/A,A/A 60,73,56    chr12   52284273    G   A       splice_donor    ANKRD33 1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  T/TACAG,T/TACAG,TACAG/TACAG 139,103,121 chr11       4592705 T   TACAG,TACAC frame_shift C11orf40    1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/T,C/T,T/T 54,76,147   chr15   40856988    C   T       splice_donor    C15orf57    1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  T/A,T/A,A/A 111,184,344 chr19   42092814    T   A       splice_acceptor CEACAM21    1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  G/GC,G/GC,GC/GC 36,59,98    chr17   30183662    G       GC  frame_shift COPRS   1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  A/AGGTGTGTGTG,A/AGGTGTGTGTG,A/A 43,98,180   chr16       88780633    AGGTGTG A,AGGTGTGTGTG   splice_donor    CTU2    1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  AT/ATA,AT/ATA,ATA/ATA   45,68,97    chr10       96827117    AT  ATA,GTA frame_shift CYP2C8  1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  GAT/G,GAT/G,G/G 34,60,96    chr1    47280745    GAT     G   frame_shift CYP4B1  1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  G/A,G/A,A/A 55,73,132   chr1    47280858    G   A       stop_gain   CYP4B1  1
    1   1_dad(father; unaffected),1_mom(mother; unaffected),1_kid(child; affected)  C/G,C/G,G/G 55,83,181   chr2    120125052   C   G       stop_gain   DBI 1
    4   4_dad(father; unaffected),4_mom(mother; unaffected),4_kid(child; affected)  G/A,G/A,A/A 115,280,113 chr12   31255262    G   A       stop_gain   DDX11   1
    3   3_dad(father; unaffected),3_mom(mother; unaffected),3_kid(child; affected)  CAATTA/C,CAATTA/C,C/C   54,65,55    chr21   34860748    CAATTA  C   frame_shift DNAJC28 1
    ...

\


Disease gene hunting!
=====================

Well, I lied to you. The four families in your database are not just randomly simulated samples.  In fact, they were simulated to represent four families where the child in each family if afflicted with a rare disease, while their parents are "normal".  Your job is to try to identify what genetic variants underlie the disease that each child has.


**Hints** (hover over to display hint):

<div title="What disease models could explain the inheritance pattern in the four families?">**Hint 1:** </div>

<div title="Each child has the same phenotype.">**Hint 2:** </div>

<div title="The children are afflicted with a known disease.">**Hint 3:** </div>

<div title="The children each have a spontaneous (de novo) mutation in the same genetic.">**Hint 4:** </div>


If you give up, the solution can be found [here](http://quinlanlab.org/tutorials/cshl2013/gemini.solution.html)


\


The GEMINI browser
==================
GEMINI also provides a built in web-browser for data exploration.

    gemini browser gemini.vcf.db

After running the above command, navigate your broswer to http://localhost:8088/query

You can now issue queries just as above, but instead the results will be provided in the browser. If selected, one can also provide hotlinks to IGV such then when a variant is selected, IGV will navigate to that location in the genome.

\


    
    
    