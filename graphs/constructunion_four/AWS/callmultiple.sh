declare -a arr=("SRR4074256" "SRR4074257" "SRR4074258" "SRR4074358" "SRR4074383" "SRR4074384" "SRR4074385" "SRR4074394" "SRR4074411" "SRR4074412" "SRR4074413")

## now loop through the above array
for i in "${arr[@]}"
do
    echo "$i"
    MASTER_IP=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
    toil clean aws:us-west-2:vgcall-yeast-constructunion-four-jobstore
    toil-vg call --vg_docker quay.io/vgteam/vg:v1.11.0-74-gdab42acd-t242-run --nodeTypes c5.2xlarge:0.2,r4.large --minNodes 0,0 --maxNodes 1,1 --provisioner aws --batchSystem mesos --mesosMaster=${MASTER_IP}:5050 --metrics aws:us-west-2:vgcall-yeast-constructunion-four-jobstore construct.xg $i.norecall.constructunion.four aws:us-west-2:vgcall-yeast-constructunion-four-outstore --gams $i.mapped.sorted.gam --chroms chrI chrII chrIII chrIV chrV chrVI chrVII chrVIII chrIX chrX chrXI chrXII chrXIII chrXIV chrXV chrXVI 2> $i.norecall.constructunion.four.log
done


