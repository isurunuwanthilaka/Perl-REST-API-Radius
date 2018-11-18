sub
{
	my $p = ${$_[0]};
	return unless $p->code() eq 'Access-Request';
	my $username = $p->getAttrByNum($Radius::Radius::USER_NAME);
	my $acctsessionidreq = $p->getAttrByNum($Radius::Radius::ACCT_SESSION_ID);
	$p->addAttrByNum($Radius::Radius::ACCT_SESSION_ID,"yyyyy");
	my $acctsessionidres = $p->getAttrByNum($Radius::Radius::ACCT_SESSION_ID);
	my $code = $p->code();
	#my $temp = $p->getAttrByNum($Radius::Radius::);
	my $timestamp = time;
	my $temp;
	
	if (open(LOGFILE, ">> c:/Program Files/Radiator/logs/postauthhooklog-accessing-req.log"))
		{
			print LOGFILE "\n\n---request received---\ntimestamp : $timestamp\nuser name : $username \nSession Id req : $acctsessionidreq\nSession Id res : $acctsessionidres\ncode : $code \nAccess-Request Recieved";
			close(LOGFILE);
			}
			
}
