package App::imgsize;

# DATE
# VERSION

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
    require Display::Resolution;
    require Image::Size;

    my %args = @_;

    my @res;
    for my $filename (@{ $args{filenames} }) {
        unless (-f $filename) {
            warn "No such file or not a file: $filename, skipped\n";
            next;
        }

        my ($x, $y) = Image::Size::imgsize($filename);

        $x ||= 0;
        $y ||= 0;

        my $res_names = Display::Resolution::get_display_resolution_name(
            width => $x, height => $y, all => 1);

        push @res, {
            filename => $filename,
            filesize => (-s $filename),
            x => $x,
            y => $y,
            res_name => $res_names ? join(", ", @$res_names) : undef,
        };
    }

    [200, "OK", \@res,
     {'table.fields' => [qw/filename filesize x y res_name/]}];
}

1;
#ABSTRACT:

=head1 SYNOPSIS

 # Use via imgsize CLI script

=cut
