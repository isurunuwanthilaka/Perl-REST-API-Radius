use JSON;
use Data::Dumper;

$json = '{"User":"isuru","Password":"3699c5bc277a4eeabe37ccf34ce491f2"}';

$text = decode_json($json);

print $text->{User},"\n";
print $text->{Password}
