sub{

	
	use DBI;
	# use Digest::MD5;
	use strict;
	use warnings;
	# Create a user agent object
	use LWP::UserAgent;

	my $p = ${$_[0]};
	return unless $p->code() eq 'Access-Request';
	my $user = $p->getAttrByNum($Radius::Radius::USER_NAME);
	my $pwd = $p->getAttrByNum($Radius::Radius::PASSWORD_NEW);
	my $acctsessionid= $p->getAttrByNum($Radius::Radius::ACCT_SESSION_ID);
	my $timestamp = time;

	my $ua = LWP::UserAgent->new;
	$ua->agent("Perl-Scripts");

	# Create a request
	my $req = HTTP::Request->new(POST => 'http://localhost:3333/api/v1/auth');
	$req->content_type('application/json');
	$req->authorization_basic("admin", "secret");
	my $s = sprintf('{"User":"%s","Password":"%s"}',$user,$pwd);
	$req->content($s);

	# Pass request to the user agent and get a response back
	my $res = $ua->request($req);

	# Check the outcome of the response
	if ($res->is_success) {
	print $res->content;
	} else {
	print $res->status_line, "n";
	}
	
	
	
	# #database details
	# my $dbname = 'perl-database';  
	# my $host = 'localhost';  
	# my $port = 5432;  
	# my $username = 'postgres';  
	# my $password = 'admin'; 

	# # Create DB handle object by connecting
	# my $dbh = DBI -> connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",
    #                         $username,
    #                         $password,
    #                         {AutoCommit => 0, RaiseError => 1}
    #                      ) or die $DBI::errstr;
	
	# my $SQL = "SELECT code,type FROM public.users WHERE username = ?";
	# my $sth = $dbh->prepare($SQL);
	# $sth->execute("$user");
	# $dbh->commit or die $DBI::errstr;

	# my @row = $sth->fetchrow_array;

	# #temporary veriables
	# my $pwd_db = $row[0];
	# my $type_db = $row[1];
	# my $c = '';
	
	if (open(LOGFILE, ">> /opt/aaa/Radiator-4.13/logs/access-request.log"))
		{
			print LOGFILE "\n---ACCESS-REQUEST-RECIEVED---\nTimestamp : $timestamp\nUser Name : $user \nSession Id : $acctsessionid\n" ;
			print LOGFILE "$pwd";
			print LOGFILE $s;
			print LOGFILE $res->content;
			close(LOGFILE);
		}

	# my $mdpwd = Digest::MD5::md5_hex($pwd_db);
	my $t =  $res->content;
	if($t eq 'Access-Accept'){
		${$_[1]}->set_code('Access-Accept');
		${$_[1]}->add_attr('Session Id','9999');	
	}
	else{
		${$_[1]}->set_code('Access-Reject');
		${$_[1]}->addAttrByNum($Radius::Radius::REPLY_MESSAGE, 'Request Denied');
		${$_[1]}->add_attr('Session Id','Null');
	}
}