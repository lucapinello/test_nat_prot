#download container
docker pull lucapinello/crispor_crispresso_nat_prot

#CRISPOR TESTING

#download genome
mkdir crispor_genomes
docker  run -v  $PWD/crispor_genomes:/crisporWebsite/genomes lucapinello/crispor_crispresso_nat_prot downloadGenome hg19 /crisporWebsite/genomes


#design guides
docker  run  -v  $PWD/crispor_genomes:/crisporWebsite/genomes -v $PWD/crispor_data:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot crispor.py hg19 crispor_input.fa crispor_output.tsv --satMutDir=./

#simulate filtering
docker run -v $PWD/crispor_data/:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot bash -c "head -n 10 REGION_1_satMutOligos.tsv > REGION_1_satMutOligos_filtered.tsv" 

#create filtered files for the experiment
docker run -v $PWD/crispor_data/:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot bash -c "join -1 1 -2 1 REGION_1_satMutOligos_filtered.tsv REGION_1_ontargetAmplicons.tsv -o 2.1,2.2,2.3 > CRISPRessoPooled_amplicons.tsv"
docker run -v $PWD/crispor_data/:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot bash -c "join -1 1 -2 1 REGION_1_satMutOligos_filtered.tsv REGION_1_ontargetAmplicons.tsv -o 2.3 | sed 1d > CRISPRessoCounts_sgRNA.tsv"
docker run -v $PWD/crispor_data/:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot bash -c "join -1 1 -2 1 REGION_1_satMutOligos_filtered.tsv REGION_1_ontargetPrimers.tsv -o 2.1,2.2,2.3,2.4,2.5,2.6,2.7 > REGION_1_ontargetPrimers_filtered.tsv"

#CRISPRESSO TESTING
docker  run -v $PWD/amplicon_data:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot  CRISPResso -r1 reads1.fastq.gz -r2 reads2.fastq.gz -a AATGTCCCCCAATGGGAAGTTCATCTGGCACTGCCCACAGGTGAGGAGGTCATGATCCCCTTCTGGAGCTCCCAACGGGCCGTGGTCTGGTTCATCATCTGTAAGAATGGCTTCAAGAGGCTCGGCTGTGGTT --g TGAACCAGACCACGGCCCGT -s 20 -q 30 -n BCL11A_exon2
docker run -v $PWD/sgRNA_data:/DATA -w /DATA lucapinello/crispor_crispresso_nat_prot CRISPRessoCount -r L3_NGG_HM_Plasmid.fastq.gz -s 20 -q 30 -f library_NGG.txt -t GTTTTAGAGCTAGAAATAGC -l 20 --name NGG_HM_PLASMID

