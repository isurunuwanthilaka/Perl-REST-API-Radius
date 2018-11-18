use strict;
use warnings;
use JSON;
use Data::Dumper;
# Create a user agent object
use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
$ua->agent("Perl-Scripts");

# Create a request
my $req = HTTP::Request->new(POST => 'http://localhost:3333/api/v1/acct/start');
$req->content_type('application/json');
$req->authorization_basic("admin", "secret");
$req->content('{"User":"isuru"}');

# Pass request to the user agent and get a response back
my $res = $ua->request($req);

# Check the outcome of the response
if ($res->is_success) {
  print $res->content,"\n";
  my $jsonObj = decode_json($res->content);
  print $jsonObj->{res},"\n";
  print $jsonObj->{AcctSessionId},"\n";
} else {
  print $res->status_line, "\n";
}