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

    # Original algorithm does it little-endian then iterates from the high byte.
    # I read it big-endian and then iterate from the low byte, saving some bit maths.
    input.unpack('N*').each do |data|
      4.times do
        table_index = (data & 0xFF) ^ (crc >> 24)
        crc = (crc << 8) & 0xFFFFFFFF
        crc = crc ^ table[table_index]
        data >>= 8
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

