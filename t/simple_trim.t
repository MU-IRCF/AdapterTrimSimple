#!/bin/env perl
use strict;
use warnings;

use Test::More;

use File::Basename;

# Testing-related modules
# use Path::Tiny qw( path     ); # path's method slurp_utf8 reads a file into a string
use File::Temp qw( tempfile ); # Function to create a temporary file
use File::Slurp qw( slurp );
use Carp       qw( croak    ); # Function to emit errors that blame the calling code

use File::Basename;

{
    # Create input file
    my $input_filename = filename_fastq(); 
    
    # Create expected output file name
    my $output_filename = remove_path_and_ext($input_filename) . '.trimmed.fa';
    
    system("lib/AdapterTrimSimple.pm $input_filename ATG TAG > $output_filename");
    
    my $expected = expected();
    
    # Read whole file into a string
    my $result = slurp $output_filename;
    
    is($result, $expected, 'correctly trimmed FASTQ file');
    
    delete_temp_file( $input_filename);
    delete_temp_file( $output_filename);
}

{
    # Create input file
    my $input_filename = filename_input2(); 
    
    # Create expected output file name
    my $output_filename = remove_path_and_ext($input_filename) . '.trimmed.fa';
    
    system("lib/AdapterTrimSimple.pm $input_filename ATGATG TAGTAG > $output_filename");
    
    my $expected = expected();
    
    # Read whole file into a string
    my $result = slurp $output_filename;
    
    is($result, $expected, 'correctly trimmed FASTQ file (alternate pre/post oligos)');
    
    delete_temp_file( $input_filename);
    delete_temp_file( $output_filename);
}

done_testing();

sub filename_fastq {
    my ( $fh, $filename ) = tempfile();
    my $string = fastq();
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub filename_input2 {
    my ( $fh, $filename ) = tempfile();
    my $string = input2();
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub delete_temp_file {
    my $filename  = shift;
    my $delete_ok = unlink $filename;
    # diag( "deleted temp file '$filename'" );
}

sub fastq
{
    return <<'END';
@parvalbumin-tidbit
ATGTCGATGACAGACTTGCTCAGCGCTTAG
+
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
END
}

sub input2
{
    return <<'END';
@parvalbumin-tidbit
ATGATGTCGATGACAGACTTGCTCAGCGCTTAGTAG
+
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
END
}

sub expected
{
    return <<'END';
>parvalbumin-tidbit
TCGATGACAGACTTGCTCAGCGCT
END
}


sub remove_path_and_ext
{
    my $file_name = shift;
    (my $extensionless_name = $file_name) =~ s/\.[^.]+$//;
    my $basename = basename($extensionless_name);
    return $basename;
}
