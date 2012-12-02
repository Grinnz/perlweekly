use strict;
use warnings;

use JSON         qw(from_json to_json);
use File::Slurp  qw(read_file write_file);
use WWW::Shorten::Bitly;
use Data::Dumper qw(Dumper);

open my $fh, '<', '/home/gabor/.bitly' or die;
chomp(my $line = <$fh>);
my ($user, $apikey) = split /:/, $line;

my $json_file = shift or die "Usage: $0 src/ddd.json\n";


my $data = from_json scalar read_file $json_file, binmode => 'utf8';
#print Dumper $data;
#print to_json $data, {utf8 => 1, pretty => 1};

for my $ch (@{ $data->{chapters} }) {
    for my $e (@{ $ch->{entries} }) {
        next if $e->{link};
        print "$e->{url}\n";
        #$e->{url} .= "&utm_medium=email&utm_campaign=PerlWeekly_$self->{issue}";
        my $bitly = WWW::Shorten::Bitly->new(URL => $e->{url}, USER => $user, APIKEY => $apikey);
        $e->{link} = $bitly->shorten(URL => $e->{url});
    }
}


#write_file $json_file, to_json($data, {utf8 => 1, pretty => 1});
write_file $json_file, { binmode => 'utf8' }, to_json($data, {utf8 => 1, pretty => 1});
