source ~/Documents/Projects/ucsc/cactus/cactus_env/bin/activate
ssh-add
toil launch-cluster -z us-west-2a cactus --keyPairName daheller@main --leaderNodeType t2.medium
cd ~/Documents/Projects/ucsc/yeast_assemblies
toil rsync-cluster -z us-west-2a cactus -avP AWSrun_181130/seqfile_yeast.txt assemblies_repeatmasked/DBVPG6044.genome.fa.masked assemblies_repeatmasked/DBVPG6765.genome.fa.masked assemblies_repeatmasked/N44.genome.fa.masked assemblies_repeatmasked/S288C.genome.fa.masked assemblies_repeatmasked/SK1.genome.fa.masked assemblies_repeatmasked/UWOPS034614.genome.fa.masked assemblies_repeatmasked/Y12.genome.fa.masked assemblies_repeatmasked/YPS128.genome.fa.masked :/
toil ssh-cluster -z us-west-2a cactus

#On AWS node
apt update
apt install -y git tmux
virtualenv --system-site-packages venv
source venv/bin/activate
git clone https://github.com/comparativegenomicstoolkit/cactus.git
cd cactus
pip install --upgrade .
cd /
screen
cactus --nodeTypes c5.4xlarge:0.4,r4.2xlarge --minNodes 0,0 --maxNodes 1,1 --provisioner aws --batchSystem mesos --metrics aws:us-west-2:cactusrun2 seqfile_yeast.txt cactusoutput2.hal

toil rsync-cluster -z us-west-2a cactus -avP :/cactusoutput2.hal .
toil destroy-cluster -z us-west-2a cactus