require_relative '../spec_helper'
require 'futurocube/resource_file'

describe FuturoCube::ResourceFile do
  before do
    @rf = FuturoCube::ResourceFile.open('FutRes031212.bin')
  end

  after do
    @rf.close
  end

  describe '::open' do
    it 'yields the ResourceFile to the block' do
      FuturoCube::ResourceFile.open('FutRes031212.bin') do |rf|
        rf.should be_a FuturoCube::ResourceFile
      end
    end
  end

  describe '#header' do
    describe '#magic' do
      it 'returns the magic number' do
        @rf.header.magic.should == 0xAA987745
      end
    end
    
    describe '#checksum' do
      it 'returns the file checksum' do
        @rf.header.checksum.should == 0x35D806F6
      end
    end
    
    describe '#version' do
      it 'returns the file format version' do
        @rf.header.version.should == 2
      end
    end

    describe '#created' do
      it 'returns the file creation date' do
        @rf.header.created.should == 1354536121
      end
    end

    describe '#name' do
      it 'returns the resource bundle name' do
        @rf.header.name.should == 'FutRes031212'
      end
    end

    describe '#record_count' do
      it 'returns the record count' do
        @rf.header.record_count.should == 274
      end
    end
    
    describe '#file_size' do
      it 'returns the file size' do
        @rf.header.file_size.should == 98828288
      end
    end
  end

  describe '#records' do
    it 'returns one element for each record in the file' do
      @rf.records.size.should == 274
    end

    describe '#name' do
      it 'returns the name of the record' do
        @rf.records[0].name.should == '1'
      end
    end

    describe '#format' do
      it 'returns a format version number' do
        @rf.records[0].format.should == 1
      end
    end
    
    describe '#data_offset' do
      it 'returns the data offset' do
        @rf.records[0].data_offset.should == 10240
      end
    end
    
    describe '#data_length' do
      it 'returns the data length' do
        @rf.records[0].data_length.should == 29184
      end
    end
  end

  describe '#data' do
    it 'returns the data for the record' do
      @rf.data(@rf.records[0]).size.should == 29184
    end
  end

  describe '#compute_checksum' do
    it 'computes the checksum for the file' do
      @rf.compute_checksum.should == @rf.header.checksum
    end
  end

end
