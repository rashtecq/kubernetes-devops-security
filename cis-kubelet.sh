#!/bin/bash
total_fail=$(kube-bench -c 4.2.1,4.2.2 --json | jq .Totals.total_fail)
if [[ "$total_fail" -ne 0 ]];
        then
            echo "CIS Benchmark Failed KUBELET while testing for 4.2.1,4.2.2"
            exit 1;
        else
            echo "CIS Benchmark Passed for KUBELET while testing 4.2.1,4.2.2"  
fi;              