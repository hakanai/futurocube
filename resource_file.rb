class ResourceFile
  class FileHeader < BinData::Record
    endian :little
    uint32 :magic
    uint32 :checksum1
    uint32 :version
    uint32 :checksum2
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

  def header
    if !@header
      @io.seek(0, IO::SEEK_SET)
      @header = FileHeader.read(@io)
    end
    @header
  end

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

  def data(rec)
    @io.seek(rec.data_offset)
    @io.read(rec.data_length)
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
