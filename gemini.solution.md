Solution
--------

    gemini de_novo  \
         -d 20 \
         --columns "chrom, start, end, gene, impact, clinvar_disease_name" \
         --filter "clinvar_disease_name is not NULL" \
    gemini.vcf.db

Results:

    family_id   family_members  family_genotypes    family_genotype_depths  chrom   start   end gene    impact  clinvar_disease_name
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    T/T,T/T,T/C 24,48,26    chr1    216011360   216011361       USH2A   non_syn_coding  .
    3   3_dad(father; affected),3_mom(mother; affected),3_kid(child; affected)  C/C,C/C,T/C 51,32,39    chr1    223284598   223284599       TLR5    non_syn_coding  Legionellosis
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    T/T,T/T,A/T 39,65,35    chr2    48030837    48030838        MSH6    downstream  .
    2   2_dad(father; unaffected),2_mom(mother; affected),2_kid(child; affected)    C/C,C/C,C/T 131,129,49  chr3    39307255        39307256    CX3CR1  non_syn_coding  Human immunodeficiency virus type 1, rapid progression to AIDS|Coronary artery disease,     resistance to|MACULAR DEGENERATION, AGE-RELATED, 12, SUSCEPTIBILITY TO
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    C/C,C/C,T/C 50,56,34    chr4    100260788   100260789       ADH1C   non_syn_coding  Alcohol dependence
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    C/C,C/C,T/C 45,88,29    chr5    35861067    35861068        IL7R    non_syn_coding  Severe combined immunodeficiency, autosomal recessive, T cell-negative, B cell-positive, NK cell-positive
    2   2_dad(father; unaffected),2_mom(mother; affected),2_kid(child; affected)    A/A,A/A,G/A 95,98,83    chr5    35871189        35871190    IL7R    non_syn_coding  Severe combined immunodeficiency, autosomal recessive, T cell-negative, B cell-positive, NK cell-   positive
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    A/A,A/A,A/G 31,60,26    chr6    42942778    42942779        PEX6    other_splice_variant    .
    1   1_dad(father; affected),1_mom(mother; unaffected),1_kid(child; affected)    GTCG/GTCG,GTCG/GTCG,GTCG/ATCA   35,59,82    chr8        52733227    52733231    PCMTD1  stop_gain   .
    1   1_dad(father; affected),1_mom(mother; unaffected),1_kid(child; affected)    G/G,G/G,G/A 45,63,132   chr10   73550968        73550969    CDH23   non_syn_coding  .
    1   1_dad(father; affected),1_mom(mother; unaffected),1_kid(child; affected)    C/C,C/C,C/T 107,141,301 chr10   135438966       135438967   FRG2B   non_syn_coding  .
    2   2_dad(father; unaffected),2_mom(mother; affected),2_kid(child; affected)    G/G,G/G,G/T 55,51,22    chr11   44297080        44297081    ALX4    synonymous_coding   .
    3   3_dad(father; affected),3_mom(mother; affected),3_kid(child; affected)  T/T,T/T,T/C 114,98,105  chr12   5021227 5021228 KCNA1       intron  Episodic ataxia type 1
    1   1_dad(father; affected),1_mom(mother; unaffected),1_kid(child; affected)    A/A,A/A,A/G 48,63,119   chr17   17700946        17700947    RAI1    non_syn_coding  Smith-Magenis syndrome
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    A/A,A/A,A/G 40,48,26    chr17   17700946    17700947        RAI1    non_syn_coding  Smith-Magenis syndrome
    3   3_dad(father; affected),3_mom(mother; affected),3_kid(child; affected)  G/G,G/G,G/A 42,44,37    chr17   17701684    17701685        RAI1    non_syn_coding  Smith-Magenis syndrome
    2   2_dad(father; unaffected),2_mom(mother; affected),2_kid(child; affected)    G/G,G/G,G/A 78,107,41   chr17   17701684        17701685    RAI1    non_syn_coding  Smith-Magenis syndrome
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    A/A,A/A,A/G 52,130,24   chrX    138633279   138633280       F9  non_syn_coding  Deep venous thrombosis, protection against


Note that the only known disease associated gene to affect all four family is RAI1; the children in each family have a spontaneous mutation in RAI1 that is causal for Smith-Magenis syndrome.

    1   1_dad(father; affected),1_mom(mother; unaffected),1_kid(child; affected)    A/A,A/A,A/G 48,63,119   chr17   17700946        17700947    RAI1    non_syn_coding  Smith-Magenis syndrome
    4   4_dad(father; unknown),4_mom(mother; unknown),4_kid(child; affected)    A/A,A/A,A/G 40,48,26    chr17   17700946    17700947        RAI1    non_syn_coding  Smith-Magenis syndrome
    3   3_dad(father; affected),3_mom(mother; affected),3_kid(child; affected)  G/G,G/G,G/A 42,44,37    chr17   17701684    17701685        RAI1    non_syn_coding  Smith-Magenis syndrome
    2   2_dad(father; unaffected),2_mom(mother; affected),2_kid(child; affected)    G/G,G/G,G/A 78,107,41   chr17   17701684        17701685    RAI1    non_syn_coding  Smith-Magenis syndrome
    
    
    
    