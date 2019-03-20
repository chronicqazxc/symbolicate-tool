# symbolicate-tool
# Tool to batch symbolicate crash files
# Wayne Jun 9, 2018

#!/bin/sh

xcode_name="$1"
crashes_path="$2"

RCol='\033[0m'
Bla='\033[33;30m';
Red='\033[33;31m';
Gre='\033[33;32m';
Yel='\033[33;33m';
Blu='\033[33;34m';
Pur='\033[33;35m';
Cya='\033[33;36m';
Whi='\033[33;37m';

function find_symbolicatecrash() {
  (printf $(find /Applications/${xcode_name}.app/Contents/SharedFrameworks -name symbolicatecrash))
}

function symbolicate_crash() {
  crash_file="$1"
  symbolicatecrash=$(find_symbolicatecrash)

  # echo "cd to $Pur${dsym_path}$Whi"
  # cd "${dsym_path}"

  if [ -f "$crash_file" ] && [ -f "$symbolicatecrash" ]
  then

    # tmp=$(./symbolicatecrash -v "${crash_file_name}.crash" XXX.app.dSYM)
    # echo "${tmp}" > ${crash_file_name}_symbolicated.crash

    filename=$(basename -- "$crash_file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    if [ ! -d "${crashes_path}/symbolicted" ]
    then
      mkdir "${crashes_path}/symbolicted"
    fi

    $symbolicatecrash -o "${crashes_path}/symbolicted/${filename}_symbolicated.crash" -v "${crash_file}"
    echo "${Blu}Symbolicate completed, plesae check ${Yel}${crashes_path}/symbolicted/${filename}_symbolicated.crash${Whi}"

  else
  	echo "$Pur${crash_file} ${Whi}or $Pur${symbolicatecrash} ${Whi}not found.${Whi}"
  fi

}

function startSymbolicating() {

    echo "${Blu}Export DEVELOPER_DIR${Whi}"
    export DEVELOPER_DIR=/Applications/${xcode_name}.app/Contents/Developer

    find "$crashes_path" -name "*.crash" | while read crash; do
      symbolicate_crash "$crash"
    done
}

if [ -d "/Applications/${xcode_name}.app" ] && [ -d "$crashes_path" ]
then
  startSymbolicating "$crashes_path"
else
	echo "$Pur/Applications/${xcode_name}.app ${Whi}or $Pur$crashes_path ${Whi}not found.${Whi}"

  echo "Please follow the command: symbolicate-tool Xcode_name Crash_logs_path"
fi
