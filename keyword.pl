#!/usr/bin/perl
############################################################################
#
# Alchemy API  LibQUAL+ Sentiment Analysis
# Author: Peter Corrigan
# Copyright (C) 2015, NUI, Galway.
#
############################################################################
use warnings;
use strict;
use AlchemyAPI;
use XML::LibXML;
use DBI;
use DBD::SQLite;

my $dbh = DBI->connect("dbi:SQLite:dbname=libqual.db","","");
my $parser = XML::LibXML->new();
my $recno=1;
# Multiline records - delimiting with first field tag
while (defined ($_ = do { local $/ = "textbox11:"; <> })) {
	print "Recno:> ",$recno, "\n";
	$recno++;
	my $alchemyObj = new AlchemyAPI();
	my $keywordParams = new AlchemyAPI_KeywordParams();
     	$keywordParams->SetSentiment(1);
	if ($alchemyObj->LoadKey("api_key.txt") eq "error") {die "Error load API key";}
	my ($commentid) = /id: (\d+)/;
	my ($date) = /SubmitDate: (.*)/gm;
	my ($usergroup) = /UserGroup: (.*)/;
	my ($discipline) = /Discipline: (.*)/;
	my ($age) = /Age: (.*)/;
	my ($comment) = /textResponse: (.*)textbox11:/gsm;
	my $recno = 1;
	if (defined $comment and length($comment)>10) {
			
			my $result;
			eval {$result = $alchemyObj->TextGetRankedKeywords($comment, $keywordParams)};
			my $source = $parser->parse_string($result) if ($result =~/<status>OK<\/status>/i);
			my @sentiment = $source->findnodes("/results/keywords/keyword/sentiment") if defined $source;
			my @relevance = $source->findnodes("/results/keywords/keyword/relevance") if defined $source;
			my @polarity = $source->findnodes("/results/keywords/keyword/sentiment/type") if defined $source;
			my @keywords  = $source->findnodes("/results/keywords/keyword/text") if defined $source;
			my $x=0;
			foreach my $rec (@sentiment) {
				my $childnode = $rec->firstChild;
				my ($score,$polarity);
				if ($rec->textContent =~ /neutral/) {
				   ($score,$polarity) =  (0,'neutral')
				}
					else
						{
							($score,$polarity) = trim($rec->textContent) =~/(-?\d+.?\d*)\s+(negative|positive)/
						}
				
					updateKeywordInstance( $score, $polarity,$relevance[$x]->textContent,$commentid,
								           $keywords[$x]->textContent );
				$x++;
			}
	}

}  # end while

sub trim {
  @_ = $_ if not @_ and defined wantarray;
  @_ = @_ if defined wantarray;
  for (@_ ? @_ : $_) { s/^\s+//, s/\s+$// }
  return wantarray ? @_ : $_[0] if defined wantarray;

}


sub recExists {
	my $kw_text = shift;
	my $keywordid;
	my $sth = $dbh->prepare( q{select keywordid from KEYWORD where keywordText = ?  })
		or die "Can't prep statement $DBI::errstr";
	my $rc = $sth->execute($kw_text) or die "Can't exec statement $DBI::errstr";
		
	while (($keywordid) = $sth->fetchrow_array){
		print "keywordid==>",$keywordid, "\n";
	}

	return $keywordid;
}

sub updateKeywordInstance {
	my ($sentimentScore, $sentimentPolarity, $relevance, $commentId,$keywordText) = @_;
	my $insertKWInstance	= 	qq{insert into KW_INSTANCE (sentimentScore,sentimentPolarity,relevance,
	commentId,keywordText) VALUES (?,?,?,?,?) };
	my $sth = $dbh->prepare($insertKWInstance) or die "Can't prep statement $DBI::errstr";
	my $rc = $sth->execute($sentimentScore, $sentimentPolarity, $relevance, $commentId,$keywordText)
		or die "Can't exec statement $DBI::errstr";
}
