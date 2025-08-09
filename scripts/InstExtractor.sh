#!/bin/bash

input_file="$1"
output_file="$2"
mem_size="$3"
mem_format="${4:-"bin"}"
use_temp="${5:-true}"

declare -a output_lines output_lines1 output_lines2 output_lines3 output_lines4
line_count=0
progress_step=16

echo "Processing instructions (max $mem_size lines)..."

to_bin32() {
    dec=$((16#$1))
    binstr=""
    for ((j=31; j>=0; j--)); do
        bit=$(( (dec >> j) & 1 ))
        binstr+=$bit
    done
    echo "$binstr"
}

add_instruction() {
    local instr="$1"
    local instr_size="$2"

    if [[ "$mem_format" == "bin" ]]; then
        dec=$((16#$instr))
        binstr=""
        for ((j=31; j>=0; j--)); do
            bit=$(( (dec >> j) & 1 ))
            binstr+=$bit
        done
        instr="$binstr"
    fi

    for (( j=$instr_size; j>=0; j-- )); do
        gap=2
        if [[ "$mem_format" == "bin" ]]; then
            gap=8
        fi
        output_lines+=("$instr")
        output_lines1+=("${instr:$((gap*0)):$((gap))}")
        output_lines2+=("${instr:$((gap*1)):$((gap))}")
        output_lines3+=("${instr:$((gap*2)):$((gap))}")
        output_lines4+=("${instr:$((gap*3)):$((gap))}")
        (( line_count++ ))
        (( line_count % progress_step == 0 )) && echo -ne "Progress: $line_count / $mem_size\r"
    done
}
while read -r line || [ -n "$line" ]; do
    if [[ "${line:0:1}" == ":" && "${line:7:2}" == "00" ]]; then
        data=${line:9:-3}
        for ((i=0; i<${#data}; i+=8)); do
            instr=${data:i:8}
            [[ ${#instr} -lt 8 ]] && instr="${instr}$(printf '0%.0s' $(seq 1 $((8 - ${#instr}))))"
            add_instruction "$instr" 0
        done
    fi
done < "$input_file"

if (( line_count < mem_size )); then
    add_instruction "00000000" $((mem_size - line_count - 1))
fi

write_outputs() {
    local base="$1"
    ext="hex"
    if [[ "$mem_format" == "bin" ]]; then
        ext="bin"
    fi
    printf "%s\n" "${output_lines[@]}" > "${base}.$ext"
    printf "%s\n" "${output_lines1[@]}" > "${base}1.$ext"
    printf "%s\n" "${output_lines2[@]}" > "${base}2.$ext"
    printf "%s\n" "${output_lines3[@]}" > "${base}3.$ext"
    printf "%s\n" "${output_lines4[@]}" > "${base}4.$ext"
}

if [[ "$use_temp" == "true" ]]; then
    temp_dir="$HOME/InstExtractor_temp"
    mkdir -p "$temp_dir" || { echo "Failed to create temp dir: $temp_dir"; exit 1; }
    tmp_base="${temp_dir}/$(basename "$output_file")"

    echo -e "\nWriting to temporary folder: $temp_dir"
    write_outputs "$tmp_base"

    echo "Moving folder to destination..."
    output_folder="$(dirname "$output_file")/mem"
    rm -rf $output_folder
    mv "$temp_dir" $output_folder
else
    write_outputs "$output_file"
fi

echo -e "\nInst-Extract Finished."
