#!/opt/local/bin/perl 
############################################################################
#
# Alchemy API  LibQUAL+ Sentiment Analysis
# Author: Peter Corrigan 
# Copyright (C) 2015, NUI, Galway.
#
############################################################################
 
use strict;
use warnings;
use AlchemyAPI;
use Date::Parse;
use DBI;
use DBD::SQLite;
my $dbh = DBI->connect("dbi:SQLite:dbname=libqual.db","","");
my $result;
my $n;

while (defined ($_ = do { local $/ = "textbox11:"; <> })) { 
	my$alchemyObj = new AlchemyAPI();	
	if ($alchemyObj->LoadKey("api_key.txt") eq "error") {die "Error load API key";}	
	my ($id) = /id: (\d+)/;
	my ($date) = /SubmitDate: (.*)/gm; 
	my ($usergroup) = /UserGroup: (.*)/;
	my ($discipline) = /Discipline: (.*)/;
	my ($age) = /Age: (.*)/;
	my ($sex) = /Sex: (.*)/;
	my ($comment) = /textResponse: (.*)textbox11:/gsm;
	if (defined $comment and length($comment)>10) {
		my $rating = $alchemyObj->TextGetTextSentiment($comment);
		my ($score)   =  $rating=~/score>(.+)<\/score>/;
		my ($polarity) =  $rating=~/<type>(.+)<\/type>/;
		#insert into my_table (id, name) values (?, ?);
		
	    my $sql=qq{INSERT INTO COMMENT (id,SubmitDate,UserGroup,Discipline,Age,Sex,textResponse,SentimentScore,SentimentPolarity)
		           VALUES (?,?,?,?,?,?,?,?,?)  };
		print "Doing> ", join "|",($id,$date,$usergroup,$discipline,$age,$sex,$score,$polarity),"\n";
		my $sth = $dbh->prepare($sql);
		my $rv = $sth->execute($id,$date,$usergroup,$discipline,$age,$sex,$comment,$score,$polarity);
		print ($rv==1) ? 'Success\n' :'Fail\n';
		$n++;
	}
}

print "\n\nProcessed $n records\n";

sub trim {
  @_ = $_ if not @_ and defined wantarray;
  @_ = @_ if defined wantarray;
  for (@_ ? @_ : $_) { s/^\s+//, s/\s+$// }
  return wantarray ? @_ : $_[0] if defined wantarray;
}
