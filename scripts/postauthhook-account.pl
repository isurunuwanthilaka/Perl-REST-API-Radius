sub
{
	my $p = ${$_[0]};
	return unless $p->code() eq 'Accounting-Request';
	my $username = $p->getAttrByNum($Radius::Radius::USER_NAME);
	my $acctsessionid = $p->getAttrByNum($Radius::Radius::ACCT_SESSION_ID);
	my $acctstatustype = $p->getAttrByNum($Radius::Radius::ACCT_STATUS_TYPE);
	my $code = $p->code();
	my $timestamp = time;

	my $c = '';

	my $ua = LWP::UserAgent->new;
	$ua->agent("Isuru");

	########type 1 : Accounting-Request : Start################################
	if ($acctstatustype eq 'Start'){
		my $req = HTTP::Request->new(POST => 'http://localhost:3333/api/v1/acct/start');
		$req->content_type('application/json');
		$req->authorization_basic("admin", "secret");
		my $s = sprintf('{"User":"%s"}',$username);
		$req->content($s);
		my $res = $ua->request($req);

		# Check the outcome of the response
		if ($res->is_success) {
			open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
			print SESSIONFILE $res->content ;
			close(SESSIONFILE);

			${$_[1]}->add_attr('Session Id',$res->{Acct-Session-Id});

		} else {
			open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
			print SESSIONFILE $res->status_line ;
			close(SESSIONFILE);
		}

		${$_[1]}->add_attr('Session Id','9999');
	}
	########type 2 : Accounting-Request : Status################################
	elsif($acctstatustype eq 'Status'){
		my $req = HTTP::Request->new(POST => 'http://localhost:3333/api/v1/acct/status');
		$req->content_type('application/json');
		$req->authorization_basic("admin", "secret");
		my $s = sprintf('{"User":"%s","AcctSessionId":"%s"}',$username,$acctsessionid);
		$req->content($s);
		my $res = $ua->request($req);

		# Check the outcome of the response
		if ($res->is_success) {
			open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
			print SESSIONFILE $res->content ;
			close(SESSIONFILE);
		} else {
			open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
			print SESSIONFILE $res->status_line ;
			close(SESSIONFILE);
		}
	}
	########type 3 : Accounting-Request : Stop################################
	elsif($acctstatustype eq 'Stop'){
		my $req = HTTP::Request->new(POST => 'http://localhost:3333/api/v1/acct/stop');
		$req->content_type('application/json');
		$req->authorization_basic("admin", "secret");
		my $s = sprintf('{"User":"%s","AcctSessionId":"%s"}',$username,$acctsessionid);
		$req->content($s);
		my $res = $ua->request($req);

		# Check the outcome of the response
		if ($res->is_success) {
			open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
			print SESSIONFILE $res->content ;
			close(SESSIONFILE);
		} else {
			open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
			print SESSIONFILE $res->status_line ;
			close(SESSIONFILE);
		}
	}

	

	
	############
	
	# if (${$_[2]} == $main::REJECT){
	# 	$c = 'Access-Request : REJECT';
	# }
	# elsif (${$_[2]} == $main::ACCEPT){
	# 	$c = 'Access-Request : ACCEPT';
	# 	open(SESSIONFILE, ">> /opt/aaa/Radiator-4.13/logs/account.log");
	# 	print SESSIONFILE "\nUsername = $username\n\tRequested Acct Session Ids = $acctsessionid";
	# 	close(SESSIONFILE);
	# }
	
	# if (open(LOGFILE, ">> /opt/aaa/Radiator-4.13/logs/account-request.log"))
	# 	{
	# 		print LOGFILE "\n---ACCOUNT-REQUEST-RECIEVED---\nTimestamp : $timestamp\nUser Name : $username\nSession Id : $acctsessionid\n$c";
	# 		close(LOGFILE);
	# 	}
}	
