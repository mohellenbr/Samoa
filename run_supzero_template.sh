# Sam(oa)² - SFCs and Adaptive Meshes for Oceanic And Other Applications
# Copyright (C) 2010 Oliver Meister, Kaveh Rahnema
# This program is licensed under the GPL, for details see the file LICENSE


#!/bin/bash

#@ job_name = samoa
#@ job_type = MPICH
#@ wall_clock_limit = $limit
#@ node = $nodes
#@ total_tasks = $processes
#@ node_usage = not_shared
#@ class = $class
#@ initialdir = $(home)/Desktop/Samoa
#@ output = $output_dir/run_p$processes_t$threads_s$sections_a$asagimode.$(jobid).out
#@ error =  $output_dir/run_p$processes_t$threads_s$sections_a$asagimode.$(jobid).err
#@ queue

. /etc/profile 2>/dev/null
. /etc/profile.d/modules.sh 2>/dev/null

export KMP_AFFINITY="granularity=core,compact,1"

echo "  Processes: "$processes
echo "  Threads: "$threads
echo "  Sections: "$sections
echo "  ASAGI mode: "$asagimode

echo "  Running Darcy..."
mpiexec -prepend-rank -n $processes ./bin/samoa_darcy -dmin 26 -dmax 40 -tsteps 10 -asagihints $asagimode -threads $threads -sections $sections > $output_dir"/darcy_p"$processes"_t"$threads"_s"$sections"_a"$asagimode".log"
echo "  Done."

echo "  Running SWE..."
mpiexec -prepend-rank -n $processes ./bin/samoa_swe -dmin 8 -dmax 30 -tsteps 100 -asagihints $asagimode -threads $threads -sections $sections > $output_dir"/swe_p"$processes"_t"$threads"_s"$sections"_a"$asagimode".log"
echo "  Done."