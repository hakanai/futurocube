class CRC
  def initialize
    reset
  end

  def reset
    @crc = 0xFFFFFFFF
  end

  def update(input)
    crc = @crc
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
    @crc = crc
  end

  def crc
    @crc
  end
end

