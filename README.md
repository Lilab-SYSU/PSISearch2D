# PSISearch2D
\###########################  

##   INSTALLATION GUIDE  ##  

\###########################

=============================
1. How to install psisearch2
=============================
This document will instruct you how to install psisearch2D

=============================
2. Install required softwares
=============================
Please install these softwares as follows beforehand:
* mysql
* ggsearch
* glsearch
* ssearch
* psiblast
Perl Module:
* DBI
* DBD::MySQL

=====================================
3. Download and Installation Guidance
=====================================
=======
PSISearch2D
=======
$wget http://lilab2.sysu.edu.cn/Tools/download/PSISearch2D.tar.gz  

$wget http://lilab2.sysu.edu.cn/Tools/download/protein_domain.sql.gz  

$gunzip protein_domain.sql.gz  

$tar zxvf PSISearch2D.tar.gz  

PSISearch2D/
     |
     |-----bin : precompile binary software :ggsearch glsearch ssearch psiblast
     |
     |-----data : score matrix 
     |
     |-----scripts : perl scripts: psisearch2_msa.pl m89_btop_msa2.pl etc
     |
     |-----test : test query dataset
 $cd psisearch2D
 $mysql -uUSERNAME -pPASSWD DBname < ./protein_domain.sql

------------------------
5 Prepare PSISearch2 DATA
------------------------
download UniProt Knowledgebase UniProtKB/Swiss-Prot database
$cd opt/database/  

$makeblastdb -in uniprot.fasta -dbtype prot 

 
*You can use your private database ,but you need to "makeblastdb -in {your database}.fasta -dbtype prot"
 

=========================
6 Test
=========================
$cd PSISearch2D/scripts  

$psisearch2d_msa_anno.pl --query ../test/testpro.txt --out_name test.result --query_seed --errors --num_iter 5 --db ../uniprot_TrEMBL/uniprot_sprot.fasta --pgm ssearch --domain_ann pfam --MySQLDB DBname --DBuser username --DBpasswd passwd
