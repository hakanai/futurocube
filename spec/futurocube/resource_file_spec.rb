require_relative '../spec_helper'
#require 'futurocube/resource_file'

describe FuturoCube::ResourceFile do
  before do
    @rf = FuturoCube::ResourceFile.open('FutRes031212.bin')
  end

  after do
    @rf.close
  end

  describe '#header' do
    it 'returns an instance of FileHeader' do
      @rf.header.should be_a_kind_of(FuturoCube::ResourceFile::FileHeader)
    end
  end

  describe '#records' do
    it 'returns one element for each record in the file' do
      @rf.records.size.should == 274
    end

    it 'returns an array of ResourceRecord' do
      @rf.records[0].should be_a_kind_of(FuturoCube::ResourceFile::ResourceRecord)
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
