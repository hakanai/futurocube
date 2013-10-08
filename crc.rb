class CRC

  def calc_block_crc(input)
    crc = 0xFFFFFFFF
    input.unpack('V*').each do |data|
      32.times do
        if ((data ^ crc) & 0x80000000) != 0
          crc = ((crc << 1) ^ 0x04C11DB7) & 0xFFFFFFFF
        else
          crc = (crc << 1)
        end
        data = (data << 1) & 0xFFFFFFFF
      end
    end
    crc
  end

end

