# AdapterTrimSimple

# Synopsis

AdapterTrimSimple.pm filename.fastq ATGAGG TTACGTG > filename.fa

“filename.fastq” should be replaced with the name of your FASTQ file.
“ATGAGG” should be replaced with the 5’ adapter (this will match perfectly).
“TTACGTG” should be replaced with the 3’ adapter (this will match perfectly).
“filename.fa” should be replaced with the desired name of your output file.

# Discussion

Pro's: Easy to use, requires no dependencies besides Perl. Should be fast, since Perl 5 has been optimized for I/O.
Con's: Missing all functionality except the very basic. This is basically a stop-gap until you can get around to installing a much nicer adapter trimmer (e.g. [cutadapt](https://cutadapt.readthedocs.io)).
