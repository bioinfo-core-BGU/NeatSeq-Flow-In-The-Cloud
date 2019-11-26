<img align="left" src="https://raw.githubusercontent.com/levinbgu/NeatSeq-Flow_Docker/master/logo.png" width="200">

# NeatSeq-Flow-In-The-Cloud

## Use cloud based HPC to run bioinformatics workflows using NeatSeq-Flow

### For more information about **"NeatSeq-Flow"** see the full documentation on **[Read The Docs](http://neatseq-flow.readthedocs.io/en/latest/)**

**Note:** For now we have tested NeatSeq-Flow on Amazon cloud (AWS ParallelCluster) using the SGE HPC scheduler. 

### To use NeatSeq-Flow on Amazon cloud using AWS ParallelCluster you will need:
1. Set-up a AWS ParallelCluster and choose a SGE HPC scheduler. Follow the information [here](https://github.com/aws/aws-parallelcluster) or [here](https://public-wiki.iucc.ac.il/index.php/How_to_create_AWS_ParallelCluster_with_Slurm_scheduler) and change slurm to sge
2. SSH to your Master Node
3. Go (cd) to your shared storage 
4. Type: 
    ```Bash
      wget https://raw.githubusercontent.com/bioinfo-core-BGU/NeatSeq-Flow-In-The-Cloud/master/Install_script.sh
      sh Install_script.sh setup_conda
      sudo Install_script.sh setup_sge 
    ```
5. Type: 
    ```Bash
      dirname $(which qsub)
    ```
6. Type: 
    ```Bash
      source activate NeatSeq_Flow
      NeatSeq_Flow_GUI.py
    ```
7. In the NeatSeq_Flow GUI in the Cluster Tab within the WorkFlow Tab, edit the 'Qsub_q' value to 'all.q' and 'Qsub_path' value to the result in step 5  
8. Open a new terminal
9. Before running a workflow activate the cluster:
    ```Bash
      pcluster start mycluster
    ```
10. To stop the cluster:
   ```Bash
      pcluster stop mycluster
   ```