class ResourceFile
  class FileHeader < BinData::Record
    endian :little
    uint32 :magic
    uint32 :checksum
    uint32 :version
    uint32 :created
    string :name, :length => 20, :trim_padding => true
    uint32 :record_count
    uint32 :file_size
  end

  class ResourceRecord < BinData::Record
    endian :little
    string :name, :length => 20, :trim_padding => true
    uint32 :format
    uint32 :data_offset
    uint32 :data_length
  end

  attr_reader :header, :records

  def initialize(io)
    @io = io
  end

  # Reads the header from the resource file.
  def header
    if !@header
      @io.seek(0, IO::SEEK_SET)
      @header = FileHeader.read(@io)
    end
    @header
  end

  # Reads the list of records from the resource file.
  def records
    if !@records
      @io.seek(44, IO::SEEK_SET)
      records = []
      header.record_count.times do
        records << ResourceRecord.read(@io)
      end
      @records = records
    end
    @records
  end

  # Reads the data for a given record.
  #
  # @param rec [ResourceRecord] the record to read the data for.
  def data(rec)
    @io.seek(rec.data_offset)
    @io.read(rec.data_length)
  end

  # Computes the checksum for the resource file.
  #
  # @yield [done, total] Provides feedback about the progress of the operation.
  def compute_checksum(&block)
    crc = CRC.new
    @io.seek(8)
    pos = 8
    length = 4096-8
    file_size = header.file_size
    block.call(0, file_size) if block
    while length > 0
      crc.update(@io.read(length))
      pos += length
      length = [4096, file_size-pos].min
      block.call(pos, file_size) if block
    end
    crc.crc
  end

  def self.open(file, &block)
    File.open(file, File::RDONLY) do |io|
      rf = ResourceFile.new(io)
      begin
        block.call(rf)
      ensure
        rf.close
      end
    end
  end

  def close
    @io.close
  end
end
