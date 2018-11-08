#!/usr/bin/perl -w
use DBI;
$ARGV[1] =~ m/(.+)\.acc/;
my $DB_name =$ARGV[2];
my $user = $ARGV[3];
my $passwd = $ARGV[4];
# if ($ARGV[1]=='pfam'){
# 	my $DB =
# }
open FILE ,$ARGV[1];
#print $ARGV[1];
my $name = $1;
open LOG ,">$name.domain";
#my $awkcl= "awk '\$2 ~/sp\|P15626\|GSTM1/ {print \$10}' $name.result.tab"
my @row ='';
my $out='';
my $q='' ;
#my $sed = '\'s/\s\\+/\t/\'';
my $dbh = DBI->connect("DBI:mysql:database=$DB_name;host=localhost","$user","$passwd",{'RaiseError'=> 1});
#my $rows = $dbh->do("INSERT INTO test(id,name) VALUES(1,'testuser')");
while(<FILE>){
	chomp;
	print LOG ">$_\n";
	my @acc=split(/[\|_]/,$_);
        my $awkcl= "awk '\$2 ~/sp\\|$acc[1]/ {print \$10}' $name.result.tab";
        my $end =`$awkcl`;
        #print $awkcl."\n";
        $end1 = chomp($end);
        #print $end."###\n";
	if ($ARGV[0] eq 'pfam'){
        $q = $dbh->prepare("SELECT pfam_id,start,end,uniprot_id FROM pfam_protein_domain_information WHERE uniprot_id='$acc[1]' order by start+0");
        $q->execute();
   # my out ='';
        my $first =0;
        my $fstart=0;
        my $fend =0;
        my $sstart =0;
        while (@row = $q->fetchrow_array())
       {my $query1 = $dbh->prepare("SELECT domain_name,pfam_id FROM pfam_domain_information WHERE pfam_id='$row[0]'");
       $query1->execute();

      # print join("\t",@row)."\n";
       my @name = $query1->fetchrow_array();
       $fstart=$row[1]-1;
      # $fend = $row[2];
      # print join("\t",@name)."\n";
#       if ($first == 0 && $fstart > 0){
#       	print LOG ('1'."\t-\t".($fstart)."\tNODOM~1:($fstart)~0\n");
#                      }
       $first +=1;
       $query1->finish();
   
    #print LOG ('1'."\t-\t".$row[1])
        if((my $t=($row[1])-1) >$fend && $first >1){
        print LOG (($fend+1)."\t-\t".$t."\tNODOM~".($fend+1).":$t~0\n");}
   	print LOG ($row[1]."\t-\t".$row[2]."\t$name[0]~$row[1]:$row[1]~$row[2]\n");
        $out=$row[2]+1;
        $fend = $row[2];
   }
  # print LOG ($out."\t-\t"."NODOM~1:");
   }elsif($ARGV[0] eq 'uniprot'){
   	$q = $dbh->prepare("SELECT domain_names,start,end,aa_length FROM uniprot_unreviewed_reviewed_all_protein_domain_information WHERE uniprot_id='$acc[1]' ORDER BY start+0 ASC");
    my $test=$q->execute();
    $test =$test+1;
    my $first =0;
    my $fend =0;
    print $test."\n";
    if ($test >1){
    while(@row = $q->fetchrow_array()){
      
    	# if ($first == 0){
    	# 	print LOG ('1'."\t-\t".$row[1]."\tNODOM~1:$row[1]~0\n");
    	# }
    	$first++;
      if((my $t=($row[1])-1) >$fend && $first >1){
        print LOG (($fend+1)."\t-\t".$t."\tNODOM~".($fend+1).":$t~0\n");}
        $row[0]=~s/\.$//g;
    print LOG ($row[1]."\t-\t".$row[2]."\t$row[0]~$row[1]:$row[1]~$row[2]\n");
        $out=$row[2]+1;
        if($row[2] >$fend){
     #   $out=$row[2]+1;
        $fend = $row[2];}
   

    }
    }else{
      print "$acc[1] does not have domain \n";
      $out =$end;
    }} 
if($end >$out){
print LOG ($out."\t-\t$end"."\tNODOM~$out:$end~0\n");}}

#print LOG ($row[2]."\t-\t"."NODOM~1:");
close LOG;
close FILE;
$q->finish();
$dbh->disconnect();

