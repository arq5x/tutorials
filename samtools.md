% samtools Tutorial
% Aaron Quinlan
% November 20, 2013


Synopsis
========

Our goal is to work through examples that demonstrate how to 
explore, process and manipulate BAM files with the `samtools`
software package.

For future reference, use the samtools [documentation](http://samtools.sourceforge.net/samtools.shtml).


\


Setup
=====
From the Terminal, create a new directory on your Desktop called "samtools-demo".

    cd ~/Desktop
    mkdir samtools-demo

Navigate into that directory.

    cd samtools-demo

Download the sample BAM file I have provided.

    wget http://quinlanlab.cs.virginia.edu/cshl2013/sample.bam


The samtools help
==================
To bring up the help, just type

    samtools

As you can see, there are multiple "subcommands" and for samtools to
work you must tell it which subcommand you want to use. Examples:

    samtools view
    samtools sort
    samtools depth


samtools "sort"
=================
When you align FASTQ files with all current sequence aligners, the
alignments produced are in random order with respect to their position
in the reference genome. In other words, the BAM file is in the order
that the sequences occurred in the input FASTQ files.

    samtools view sample.bam | head

Doing anything meaningful (e.g.) calling variants or visualizing
alignments in IGV) requires that the BAM is sorted such that the 
alignments occur in "genome order"

    samtools sort sample.bam sample.sorted

Now let's check the order:

    samtools view sample.sorted.bam | head


\


samtools "index"
================

Indexing a genome sorted BAM file allows one to quickly extract alignments
overlapping particular genomic regions. Moreover, indexing is required by genome viewers such as IGV so that the viewers can quickly display alignments in each genomic region to which you navigate.

    samtools index sample.sorted.bam

This will create an additional "index" file. List (`ls`) the contents of the current directory and look for the new index file.

    ls 

Now, let's exploit the index to extract alignments from the 33rd megabase
of chromosome 1. To do this, we use the samtools `view` command, which we will give proper treatment in the next section. For now, just do it without understanding. No really. Do it.

    samtools view sample.sorted.bam 1:33000000-34000000

How many alignments are there in this region?

    samtools view sample.sorted.bam 1:33000000-34000000 | wc -l


\


samtools "view"
================

The samtools `view` command is the most versatile tool in the samtools package. It's main function, not surprisingly, is to allow you to convert the binary (i.e., easy for the computer to read and process) alignments in the BAM file view to text-based SAM alignments that are easy for *humans* to read and process.


Scrutinize some alignments
--------------------------
Let us start by inspecting the first five alignments in our BAM in detail.

    samtools view sample.sorted.bam | head -n 5


Let's make the FLAG more readable
---------------------------------
Let us start by inspecting the first five alignments in our BAM in detail.

    samtools view -X sample.sorted.bam | head -n 5

You can use the detailed help to get a better sense of what each character in the human "readable" FLAG means. See section 6 of the Notes.

    samtools view -?


Count the total number of alignments.
-------------------------------------
    samtools view sample.sorted.bam | wc -l


Inspect the header.
--------------------
The "header" in a BAM file records important information regarding the 
reference genome to which the reads were aligned, as well as other information about how the BAM has been processed. One can ask the `view`
command to report solely the header by using the `-H` option.

    samtools view -H sample.sorted.bam


Capture the FLAG.
-------------------------------------
As we discussed earlier, the FLAG field in the BAM format encodes several key pieces of information regarding how an alignment aligned to the reference genome. We can exploit this information to isolate specific types of alignments that we want to use in our analysis.

For example, we often want to call variants solely from paired-end sequences that aligned "properly" to the reference genome. Why?

To ask the `view` command to report solely "proper pairs" we use the `-f` option and ask for alignments where the second bit is true (proper pair is true).

    samtools view -f 0x2 sample.sorted.bam

How many *properly* paired alignments are there?

    samtools view -f 0x2 sample.sorted.bam | wc -l

Now, let's ask for alignments that are NOT properly paired.  To do this, we use the `-F` option (note the capitalization to denote "opposite").

    samtools view -F 0x2 sample.sorted.bam

How many *improperly* paired alignments are there?

    samtools view -F 0x2 sample.sorted.bam | wc -l

Does everything add up?


What else should we test?
-------------------------------------


\



Other options.
====================
There are many other options for the `view` command.  This is merely meant to be an appetizer.  Please look through the help, as well as visit the samtools [documentation](http://samtools.sourceforge.net/samtools.shtml) site.

