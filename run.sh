#!/bin/sh
#
# runs the isatomic test and summarizes into a table without details to stdout

set -eu

cmake -B build/ -S . -DCMAKE_BUILD_TYPE=Release >/dev/null 2>&1
cmake --build build >/dev/null
prog=build/isatomic

cpu=$(cat /proc/cpuinfo |grep "model name" |head -n1 |cut -f2 -d:)


for T in 128 128u 128s 256 256u 256s 512 512s; do
    if $prog -t $T>/dev/null; then
	printf '%-5s %s\n' $T OK
    else
	printf '%-5s %s\n' $T FAILED
    fi
done

# show the avx flags
echo "=============================="
echo "cpu: $cpu"
echo "avx flags:"
grep ^flags /proc/cpuinfo  |head -n1 |cut -f2 -d: |xargs -n1 echo |grep avx |sort
