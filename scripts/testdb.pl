use DBI;

my $dbname = 'perl-database';  
my $host = 'localhost';  
my $port = 5432;  
my $username = 'postgres';  
my $password = 'test'; 

# Create DB handle object by connecting
my $dbh = DBI -> connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",
                            $username,
                            $password,
                            {AutoCommit => 0, RaiseError => 1}
                         ) or die $DBI::errstr;

#instert data to the databse for the first time.
# my $SQL = "INSERT INTO public.users (username,code,type)
# VALUES ('lochana', 't09tnjndrg9','TKN'),
# ('mikem', 'fred','PWD'),
# my $sth = $dbh->do($SQL);
# $dbh->commit or die $DBI::errstr;

#set user login data
my $psw;
my $user = 'mikem';

#retrieve user password
$SQL = "SELECT code,type FROM public.users WHERE username = ?";
$sth = $dbh->prepare($SQL);
$sth->execute("$user");
$dbh->commit or die $DBI::errstr;

my @row = $sth->fetchrow_array;

#temporary veriables
my $pwd_db = $row[0];
my $type_db = $row[1];
print "\npass type \t: $type_db\nuser pass\t: $pwd_db";
