class CRC
  def initialize
    @table = make_table(0x04C11DB7)
    reset
  end

  def reset
    @crc = 0xFFFFFFFF
  end

  def update(input)
    crc = @crc
    table = @table

    input.unpack('V*').each do |data|
      4.times do
        table_index = (data >> 24) ^ (crc >> 24)
        crc = (crc << 8) & 0xFFFFFFFF
        crc = crc ^ table[table_index]
        data = (data << 8) & 0xFFFFFFFF
      end
    end

    @crc = crc
  end

  def crc
    @crc
  end

private

  def make_table(poly)
    (0..255).map do |n|
      crc = n << 24
      8.times do
        if crc & 0x80000000 != 0
          crc = ((crc << 1) ^ poly) & 0xFFFFFFFF
        else
          crc <<= 1
        end
      end
      (crc & 0xFFFFFFFF)
    end
  end

end

