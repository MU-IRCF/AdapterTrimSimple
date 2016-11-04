#!/usr/bin/env perl
package AdapterTrimSimple;
use 5.010;
use strict;
use warnings;
use autodie;

################################################################################
# handle command line arguments
#------------------------------------------------------------------------------

# Capture the first command line argument as the file name
my $filename_in = shift // exit_giving_usage();

# Get the starting and ending adapter sequences from the command line
my $pre_capture_oligo  = shift // exit_giving_usage();
my $post_capture_oligo = shift // exit_giving_usage();

# If there is a command flag, exit and give the usage information (because we're not using flags)
exit_giving_usage() if grep { looks_like_flag($_) } ( $filename_in, $pre_capture_oligo, $post_capture_oligo);

#------------------------------------------------------------------------------
################################################################################

# create input and output file handles
open( my $fh_in,  '<', $filename_in );

while( my $header = readline $fh_in)
{ 
    my $sequence = readline $fh_in;

    # Ignoring these for now
    my $qual_header = readline $fh_in;
    my $qual_scores = readline $fh_in;

    chomp($header, $sequence, $qual_header, $qual_scores);

    $header = '>' . substr($header,1);

    if ( $sequence =~ / $pre_capture_oligo ( .+ ) $post_capture_oligo /xms )
    {
        $sequence = $1;
        say $header;
        say $sequence;
    }
    else 
    {
        warn "$sequence not matched";
    }
}

sub exit_giving_usage 
{
    warn <<"END";
USAGE:
    $0 in_file_name.fq pre_capture_oligo post_capture_oligo > out_file_name.fa 
    Input file name can be anything.
    "pre_capture_oligo" is conserved sequence right before the variable region
    "post_capture_oligo" is conserved sequence right after the variable region
END
    exit;
}

sub looks_like_flag 
{
    my $arg = shift;
    return index($arg, '-') == 0;
}

=head1 NAME
adapter_trim_simple - translates a cDNA sequence
=head1 SYNOPSIS
adapter_trim_simple E<lt> filename.fa E<gt>
=head1 DESCRIPTION 
The script will trim one Fasta nucleotide file
=head1 FEEDBACK
=head2 Reporting Bugs
Report bugs via GitHub (https://github.com/MU-IRCF/AdapterTrimSimple/issues). 
=head1 AUTHORS
  Christopher Bottoms
=cut
