#!/bin/bash
total_fail=$(kube-bench -c 2.1,2.2 --json | jq .Totals.total_fail)
if [[ "$total_fail" -ne 0 ]];
        then
            echo "CIS Benchmark Failed ETCD while testing for 2.1,2.2"
            exit 1;
        else
            echo "CIS Benchmark Passed for ETCD while testing 2.1,2.2"  
fi; 