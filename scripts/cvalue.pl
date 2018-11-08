#!/usr/bin/perl -w
use strict;
#use POSIX qw(log10);
#use Math::Complex;
our %DomainHash;
my %Evalue;
#open out ,$ARGV[1];
$ARGV[0] =~ m/(.+)\.domain/;
my $name = $1;
#####################
open SubjectFile,$ARGV[1];
my %EvalueHash;
my %subjectLength;
my $queryname;
my $firstSubjectName;
my $tem = 0;
while(<SubjectFile>){
             if ($_ !~ /^#/){
              #print $_;
              my @line = split("\t",$_);
              # print $line[1]."\n";
              my @name = split('\|',$line[1]);
              if ($tem == 0){
                $firstSubjectName = $name[1];
                $tem =1;
              }
              my @queryNameArray = split('\|',$line[0]);
             $queryname = $queryNameArray[1];
              #print "array".@name."\n";
              #print $name[1]."\n";
             # print $name[1]."\n";
              # print $line[10]."\n";
              $EvalueHash{$name[1]}=$line[10];
              $subjectLength{$name[1]}=$line[9];}
#              print $name[1]."\n";
#              print $line[10]."\n";
#              $EvalueHash{$name[1]}=$line[10];
                   }
close(SubjectFile);
##################################
open DomainFile ,$ARGV[0];
my $out;
my $tem2 =0;
our %domainlenth;
while(<DomainFile>){
	if ($_ =~ /^>/){
               if($tem2 != 0 )
               {
               # print "##########################\n";
               #  print "##########$out \n";
               # print %domainlenth;
               # print "#############\n";
               # print %domainlenth;
               # print "###########\n";
               $DomainHash{$out} = {%domainlenth};
               print "#############\n";
               # my $tst = /$DomainHash{$out};
               print %{$DomainHash{$out}}; 
               print "#############\n";
               # for my $domainkeys (keys ${$DomainHash{$out}}){
               #  print $DomainHash{$out}{$domainkeys};
               # }
               # print "###############$out";
               # print $DomainHash{$out};
               # # print "##########$out \n";
               # my @temkeys = keys $DomainHash{$out};
               # my @temkeys1 = keys %domainlenth;
               # print "#######".@temkeys;
               # print "#######".@temkeys1;
             }
               $tem2 +=1;
               %domainlenth =(); 
               my @acc = split('\|',$_);
               $out = $acc[1];
               # print "##########$out \n";
               # print "##########$tem2 \n";
	}else{
             if($_ !~ /NODOM/){
             my @domain =split("\t",$_);
             my $domainName = (split("~",$domain[3]))[0];
              # print $domainName."\n";
             my $length =$domain[2]-$domain[0];
             $domainlenth{$domainName}=$length;
             # print "##################\n";
             # print %domainlenth;
             # print "##################\n";
             # print "\n";
             #  # print $domainlenth{$domainName}."\n";
             # print $length."\n";
             # $domainlenth += $length;
             # print $domainlenth."\n";
              }
              }
              }
close(DomainFile);
# open SubjectFile,$ARGV[1];
# my %EvalueHash;
# my %subjectLength;
# my $queryname;
# while(<SubjectFile>){
#              if ($_ !~ /^#/){
#               #print $_;
#               my @line = split("\t",$_);
#               print $line[1]."\n";
#               my @name = split('\|',$line[1]);
# #              $queryname = split('\|',$line[0])[0];
#               #print "array".@name."\n";
#               #print $name[1]."\n";
#              # print $name[1]."\n";
#               print $line[10]."\n";
#               $EvalueHash{$name[1]}=$line[10];
#               $subjectLength{$name[1]}=$line[9];}
# #              print $name[1]."\n";
# #              print $line[10]."\n";
# #              $EvalueHash{$name[1]}=$line[10];
#                    }
# close(SubjectFile);
# print "canshu".$ARGV[2]."\n";
my $eValueThreshold=$ARGV[2];
#####Get queryDomain######
my %queryDomain;
my @key = keys %DomainHash;
# print @key."#############################DomainHash\n";
if(grep {$_ eq $queryname} @key){
 %queryDomain = %{$DomainHash{$queryname}};
 # print %{$DomainHash{$queryname}};
 # print keys %queryDomain;
}else{
  %queryDomain = %{$DomainHash{$firstSubjectName}};
}
 print %queryDomain;
# print join(keys %queryDomain ,"\t");

#########################
#      log10            #
#########################
sub log10{my $n = shift;
          return log($n)/log(10);
        }
########################
open out1,">$name.cvalue.tem";
print out1 "Subjectname\tCvalue\n" ;
# foreach my $key (keys %DomainHash){
#                 print $key."\n";
#                 my $Wd = -log10($eValueThreshold);
#                 if($subjectLength{$key}){
#                 print $EvalueHash{$key}."\n";
#                 print log10($EvalueHash{$key})."\n";
#                 my $Cvalue = $Wd * ($DomainHash{$key}/$subjectLength{$key}) - log10($EvalueHash{$key});
#                 print out1 "$key\t$Cvalue\n";}
#                 else{
#                 print "Domainlength:$DomainHash{$key}\n";
#                 print "subjectLength:$subjectLength{$key}\n";}
# }
foreach my $i (keys %subjectLength){
          my $Wd = -log10($eValueThreshold);
          our $eValuSub = $EvalueHash{$i};
          my @queryDomainKeys = keys %queryDomain;
          my $allDomainLength = 0;
          if ($DomainHash{$i}){
          for my $k (keys %{$DomainHash{$i}}){
            if (grep {$_ eq $k} @queryDomainKeys){
              # print "#################subjectdomain match name### $k \n";
              $allDomainLength += $DomainHash{$i}{$k};
              # print $allDomainLength;
            }
            }
          }
          if ($eValuSub == 0){
            $eValuSub = 10**(-250);
          }
         print "subjectname###########$i\n";
         print "Domainlength##########$allDomainLength\n";
         my $Cvalue = $Wd * ($allDomainLength/$subjectLength{$i}) - log10($eValuSub);
         print out1 "$i\t$Cvalue\n";
       }

close(out1);
system("sed -n '1p' $name.cvalue.tem >header.tem");
system("sort -k2nr $name.cvalue.tem >cvalue");
system("cat header.tem cvalue >$name.cvalue");
system("sed -i '\$d' $name.cvalue");