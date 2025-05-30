#! /bin/bash

submit=${1:-'test'}
nFile=${2:-'0'}
nevts=${3:-'0'}
minpt=${4:-'1.0'}
i=0
if [[ $nFile -eq 0 ]]; then 
	nFile=`wc -l < dst_truth_jet_30.list`
fi 
for i in $(seq 0 ${nFile}); do 
	j=$(( i+1 ))
	fname="condor_files/condor_segment_"$i"_30.job"
	data="none" 	 
	truthf=`sed "${j}q;d" dst_truth_30.list`
	truthfr=`sed "${j}q;d" dst_truth_reco_30.list`
	truthj=`sed "${j}q;d" dst_truth_jet_30.list`
	caloclusterf=`sed "${j}q;d" dst_calo_cluster_30.list`
	globalf=`sed "${j}q;d" dst_global_30.list`
	
	echo "Universe 	        = vanilla " > $fname
	echo "Executable 	= /gpfs/mnt/gpfs02/sphenix/user/sgross/sphenix_analysis/EnergyCorrelatorsJets/LargeRLCaloENC/macros/RunLargeRLENC.sh " >>$fname
	echo "Arguments         = ${data} none none none ${truthf} ${truthj} ${caloclusterf} ${truthfr} ${globalf} ${nevts} ${minpt}" >> $fname 
	echo "Output  	        = /gpfs/mnt/gpfs02/sphenix/user/sgross/sphenix_analysis/EnergyCorrelatorsJets/LargeRLCaloENC/macros/condor_files/condor_${i}.out " >> $fname
	echo "Error 		= /gpfs/mnt/gpfs02/sphenix/user/sgross/sphenix_analysis/EnergyCorrelatorsJets/LargeRLCaloENC/macros/condor_files/condor_${i}.err " >> $fname
	echo "Log  		= /gpfs/mnt/gpfs02/sphenix/user/sgross/sphenix_analysis/EnergyCorrelatorsJets/LargeRLCaloENC/macros/condor_files/condor_${i}.log" >> $fname
	echo "Initialdir  	= /gpfs/mnt/gpfs02/sphenix/user/sgross/sphenix_analysis/EnergyCorrelatorsJets/LargeRLCaloENC/root_output_30" >> $fname
	echo "PeriodicHold 	= (NumJobStarts>=1 && JobStatus == 1)" >>$fname
	echo "accounting_group = group_phenix.u " >> $fname
	echo "accounting_group_user = sgross " >> $fname
	echo "request_memory = 128 GB " >> $fname
	echo "Priority = 90 ">> $fname
	echo "job_lease_duration = 3600" >> $fname
	echo "Queue 1" >> $fname 
if [[ $submit == "submit" ]]; then 
	condor_submit $fname
fi 		
done 
