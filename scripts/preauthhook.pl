sub
{
	my $p = ${$_[0]};
	#return unless $p->code() eq 'Access-Request';
	my $username = $p->getAttrByNum($Radius::Radius::USER_NAME);
	my $nasaddress = $p->getAttrByNum($Radius::Radius::NAS_IP_ADDRESS);
	my $code = $p->code();
	my $timestamp = time;
	
	if (open(LOGFILE, ">> c:/Program Files/Radiator/logs/preauthhooklog.log"))
		{
			print LOGFILE "\n---request received---\ntimestamp : $timestamp\nuser name : $username \nnasaddress : $nasaddress\ncode : $code";
			close(LOGFILE);
			}
}	