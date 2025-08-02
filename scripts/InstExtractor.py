# 每个文件的最大字节数
max_lines = 8192

# Python程序从Intel HEX文件中读取RISC-V指令并列出a
def parse_hex_line(line):
    """
    解析一行Intel HEX文件 ， 返回一个元组 (数据长度, 地址, 记录类型, 数据)。，，，，，，，，，，，，
    """
    line = line.strip()
    if line[0] != ':':
        raise ValueError("Invalid HEX line")

    byte_count = int(line[1:3], 16)
    address = int(line[3:7], 16)
    record_type = int(line[7:9], 16)
    data = line[9:9 + byte_count * 2]
    checksum = int(line[9 + byte_count * 2:], 16)

    return address, record_type, data

def extract_code(file_path):
    """
    从Intel HEX文件中读取数据，并返回包含RISC-V程序指令的列表。
    """
    instructions = []

    with open(file_path, 'r') as file:
        for line in file:
            try:
                address, record_type, data = parse_hex_line(line)
                if record_type == 0:  # 数据记录
                    # 每两个字符是1字节
                    for i in range(0, len(data), 8):
                        chunk = data[i:i+8]
                        # 如果不满8字符（即不足4字节），末尾补0
                        if len(chunk) < 8:
                            chunk = chunk.ljust(8, '0')
                        instructions.append((hex(address), chunk))
                        address += 4  # 每条指令占4字节
            except ValueError as e:
                print(f"Skipping invalid line: {line}")

    return instructions

def save_bytes_to_files(instructions, output_dir, output_format='bin'):
    """
    将每条指令的每个字节保存为8位二进制字符串到文本文件中。
    - 第一个文件保存完整32位二进制字符串（固定为 .hex）
    - 其余四个保存8位二进制字符串，根据 output_format 命名为 .hex 或 .bin
    """
    assert output_format in ['hex', 'bin'], "output_format must be 'hex' or 'bin'"

    file_names = [
        f'{output_dir}.hex',  # 完整32位，每行8 hex digit -> 32 bit binary
        f'{output_dir}0.{output_format}',
        f'{output_dir}1.{output_format}',
        f'{output_dir}2.{output_format}',
        f'{output_dir}3.{output_format}'
    ]

    # 内容容器
    content = [[] for _ in range(5)]
    for address, inst in instructions:
        content[0].append(inst)
        # 后四个文件：分别取两个字符，转为 8位二进制
        for i in range(4):
            byte_hex = inst[i*2:i*2+2]
            byte_bin = bin(int(byte_hex, 16))[2:].zfill(8)
            content[i+1].append(byte_bin)

    # 写入五个文件
    for i in range(5):
        fname = file_names[i]
        is_full = (i == 0)
        lines = content[i]
        padding = max_lines - len(lines)
        with open(fname, 'w') as f:
            f.writelines(line + '\n' for line in lines)
            f.writelines(('0' * 8 + '\n') * padding)

    print(f"Saved {len(instructions)} instructions in binary string format to '{output_dir}'")


if __name__ == '__main__':
    # input_file_path = 'test/cyber/build/demo.hex'
    # output_file_path = 'test/cyber/demo'
    input_file_path = 'test/cyberwithddr/build/demo.hex'
    output_file_path = 'test/cyberwithddr/demo'
    instructions = extract_code(input_file_path)

    # 将每个字节保存到不同的文件中
    save_bytes_to_files(instructions, output_file_path)
