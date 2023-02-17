#!/bin/bash
GRN='\x1B[32m'
END='\x1B[0m'

files=("build/ios/Release-iphoneos/Runner.app/Runner" "build/ios/iphoneos/Runner.app/Runner")

for file in ${files[@]}; do
    echo -e "${GRN}check binary file ${file}${END}"
    bash -c "nm ${file} | egrep 'T _PinStatic'"
    bash -c "nm ${file} | egrep 'T _K8zRequest'"
    bash -c "nm ${file} | egrep 'T _FreePointer'"
    bash -c "nm ${file} | egrep 'T _LocalServerAddr'"
    bash -c "nm ${file} | egrep 'T _StartLocalServer'"
done
