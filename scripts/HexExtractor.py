# 每个文件的最大字节数
max_bytes = 8192

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
                # 我们只关心数据记录类型（通常为0）
                if record_type == 0:
                    # 将16进制数据分成4字节的RISC-V指令
                    for i in range(0, len(data), 8):  # 8个字符是4字节（32位）的指令
                        instruction = data[i:i+8]
                        instructions.append((hex(address), instruction))
                        address += 4  # RISC-V指令是32位(4字节)，地址每次增加4

            except ValueError as e:
                print(f"Skipping invalid line: {line}")

    return instructions

def save_bytes_to_files(instructions, output_dir):
    """
    将每条指令的每个字节保存到四个不同的文件中，确保每个文件写入4096字节数据。
    """
    file_names = [f'{output_dir}.hex', f'{output_dir}0.hex', f'{output_dir}1.hex', f'{output_dir}2.hex', f'{output_dir}3.hex']

    # 记录每个文件的字节内容
    bytes_content = [[] for _ in range(5)]

    # 收集每个字节的内容
    for address, instruction in instructions:
        bytes_content[0].append(instruction)  # 全部字节
        bytes_content[1].append(instruction[0:2])  # 第一个字节
        bytes_content[2].append(instruction[2:4])  # 第二个字节
        bytes_content[3].append(instruction[4:6])  # 第三个字节
        bytes_content[4].append(instruction[6:8])  # 第四个字节

    # 将字节内容写入文件，并确保文件大小为4096字节
    for i in range(5):
        with open(file_names[i], 'w') as file:
            # 写入实际字节
            for byte in bytes_content[i]:
                file.write(byte + '\n')

            # 填充0到4096字节
            if len(bytes_content[i]) < max_bytes:
                # 计算需要填充的零数量
                padding_size = max_bytes - len(bytes_content[i])
                if i == 0:
                    file.writelines(['00000000\n'] * padding_size)  # 填充零
                else:
                    file.writelines(['00\n'] * padding_size)  # 填充零
    
    print(f"Saved {len(instructions)} instructions to {output_dir}")


if __name__ == '__main__':
    # input_file_path = 'test/cyber/build/demo.hex'
    # output_file_path = 'test/cyber/demo'
    input_file_path = 'test/cyberwithddr/build/demo.hex'
    output_file_path = 'test/cyberwithddr/demo'
    instructions = extract_code(input_file_path)

    # 将每个字节保存到不同的文件中
    save_bytes_to_files(instructions, output_file_path)
