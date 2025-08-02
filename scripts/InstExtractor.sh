#!/bin/bash

input_file="$1"
output_file="$2"
mem_size="$3"
mem_format="${4:-"bin"}"
use_temp="${5:-true}"

output_lines=()
output_lines1=()
output_lines2=()
output_lines3=()
output_lines4=()
line_count=0
progress_step=16

echo "Processing instructions (max $mem_size lines)..."

while read -r line || [ -n "$line" ]; do
    if [[ "${line:0:1}" == ":" && "${line:7:2}" == "00" ]]; then
        data=${line:9:-3}
        for ((i=0; i<${#data}; i+=8)); do
            instr=${data:i:8}
            while (( ${#instr} < 8 )); do
                instr="${instr}0"
            done

            if [[ "$mem_format" == "bin" ]]; then
                dec=$((16#$instr))
                binstr=""
                for ((j=31; j>=0; j--)); do
                    bit=$(( (dec >> j) & 1 ))
                    binstr+=$bit
                done
                output_lines+=("$binstr")
                output_lines1+=("${binstr:0:8}")
                output_lines2+=("${binstr:8:8}")
                output_lines3+=("${binstr:16:8}")
                output_lines4+=("${binstr:24:8}")
            else
                output_lines+=("$instr")
                output_lines1+=("${instr:0:2}")
                output_lines2+=("${instr:2:2}")
                output_lines3+=("${instr:4:2}")
                output_lines4+=("${instr:6:2}")
            fi

            ((line_count++))
            if (( line_count % 16 == 0 )); then
                echo -ne "Progress: $line_count / $mem_size\r"
            fi
        done
    fi
done < "$input_file"

while (( line_count < mem_size )); do
    if [[ "$mem_format" == "bin" ]]; then
        output_lines+=("00000000000000000000000000000000")
        output_lines1+=("00000000")
        output_lines2+=("00000000")
        output_lines3+=("00000000")
        output_lines4+=("00000000")
    else
        output_lines+=("00000000")
        output_lines1+=("00")
        output_lines2+=("00")
        output_lines3+=("00")
        output_lines4+=("00")
    fi
    ((line_count++))
    if (( line_count % progress_step == 0 )); then
        echo -ne "Progress: $line_count / $mem_size\r"
    fi
done


if [[ "$use_temp" == "true" ]]; then
    temp_dir="$HOME/InstExtractor_temp"
    mkdir -p "$temp_dir" || { echo "Failed to create temp dir: $temp_dir"; exit 1; }
    tmp_output_file="${temp_dir}/$(basename "$output_file")"

    echo -e "\nWriting to temporary folder: $temp_dir"
    printf "%s\n" "${output_lines[@]}" > "${tmp_output_file}.mem"
    printf "%s\n" "${output_lines1[@]}" > "${tmp_output_file}1.mem"
    printf "%s\n" "${output_lines2[@]}" > "${tmp_output_file}2.mem"
    printf "%s\n" "${output_lines3[@]}" > "${tmp_output_file}3.mem"
    printf "%s\n" "${output_lines4[@]}" > "${tmp_output_file}4.mem"

    echo "Copying files back to destination..."
    cp "${tmp_output_file}.mem"  "${output_file}.mem"
    cp "${tmp_output_file}1.mem" "${output_file}1.mem"
    cp "${tmp_output_file}2.mem" "${output_file}2.mem"
    cp "${tmp_output_file}3.mem" "${output_file}3.mem"
    cp "${tmp_output_file}4.mem" "${output_file}4.mem"

    echo "Cleaning up temp folder..."
    rm -rf "${temp_dir}"
else
    printf "%s\n" "${output_lines[@]}" > "${output_file}.mem"
    printf "%s\n" "${output_lines1[@]}" > "${output_file}1.mem"
    printf "%s\n" "${output_lines2[@]}" > "${output_file}2.mem"
    printf "%s\n" "${output_lines3[@]}" > "${output_file}3.mem"
    printf "%s\n" "${output_lines4[@]}" > "${output_file}4.mem"
fi


echo -e "\nInst-Extract Finished."
