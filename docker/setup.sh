#!/bin/bash
echo "" | sudo tee /proc/sys/kernel/core_pattern
echo 0 | sudo tee /proc/sys/kernel/core_uses_pid
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
echo 1 | sudo tee /proc/sys/kernel/sched_child_runs_first
echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
