package App::imgsize;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(imgsize);

$SPEC{imgsize} = {
    v => 1.1,
    summary =>
        'Show dimensions of image files',
    args => {
        filenames => {
            'x.name.is_plural' => 1,
            schema => ['array*' => {of => 'filename*'}],
            req => 1,
            pos => 0,
            greedy => 1,
        },
    },
};
sub imgsize {
    require Image::Size;

    my %args = @_;

    my @res;
    for my $filename (@{ $args{filenames} }) {
        unless (-f $filename) {
            warn "No such file or not a file: $filename, skipped\n";
            next;
        }

        my ($x, $y) = Image::Size::imgsize($filename);

        push @res, {
            filename => $filename,
            filesize => (-s $filename),
            x => $x,
            y => $y,
        };
    }

    [200, "OK", \@res,
     {'table.fields' => ['filename', 'x', 'y', 'filesize']}];
}

1;
#ABSTRACT:

=head1 SYNOPSIS

 # Use via imgsize CLI script

=cut
