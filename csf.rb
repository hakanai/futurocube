#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative 'resource_file'
require_relative 'crc'

INPUT_FILE = 'FutRes031212.bin'
file_size = File.size(INPUT_FILE)
block_size = File.stat(INPUT_FILE).blksize || 4096

def with_progress(title, total, &block)
  progress = ProgressBar.new(title, total)
  progress.format = '%-30s %3d%% %s %s'
  block.call(progress)
  progress.finish
end

File.open(INPUT_FILE, 'rb') do |io|
  #@io.seek(0, IO::SEEK_SET)
  rf = ResourceFile.new(io)
  checksum1 = rf.header.checksum1
  checksum2 = rf.header.checksum2
  puts "searching #{file_size} bytes for #{checksum1} and #{checksum2}"

  file_data = String.new
  with_progress('reading file', file_size) do |progress|
    io.seek(0, IO::SEEK_SET)
    (0...file_size).each do |offset|
      buffer_offset = offset % block_size
      if buffer_offset == 0
        file_data << io.read(block_size)
        progress.inc(block_size)
      end
    end
  end

  p checksum2
  puts '--------------------'

  crc = CRC.new

  offsets = [16, 36, 40, 44, 44+32*rf.header.record_count, 10240, file_size]
  offsets.each do |offset1|
    offsets.each do |offset2|
      if offset2 > offset1
        result = crc.calc_block_crc(file_data.slice(offset1, offset2 - offset1))
        puts "#{offset1}..#{offset2} = #{result}"
      end
    end
  end

  puts '--------------------'

  # crc32_values = []
  # #adler32_values = []
  # (0..255).each do |byte|
  #   one = ''
  #   one << byte
  #   crc32_values << Zlib::crc32(one)
  #   #adler32_values << Zlib::adler32(one)
  # end

  # crc32_ones = Array.new(file_size, 0)
  # with_progress('initial checksums', file_size) do |progress|
  #   (0...file_size).each do |offset|
  #     if offset % block_size == 0
  #       progress.inc(block_size)
  #     end
  #     crc32_ones[offset] = crc32_values[file_data.getbyte(offset)]
  #   end
  # end

  # crc32s = Array.new(file_size, 0)
  # with_progress('combining checksums', file_size) do |progress|
  #   (1..file_size).each do |length|
  #     (0..(file_size-length)).each do |offset|
  #       if length == 1
  #         crc32s[offset] = crc32_ones[offset]
  #       else
  #         crc32s[offset] = Zlib::crc32_combine(crc32s[offset], crc32_ones[offset + 1], 1)
  #       end

  #       if crc32s[offset] == checksum1
  #         puts "CRC-32 match for checksum1 at offset = #{offset}, length = #{length}"
  #       end
  #       if crc32s[offset] == checksum2
  #         puts "CRC-32 match for checksum2 at offset = #{offset}, length = #{length}"
  #       end
  #     end

  #     progress.inc
  #   end
  # end
end
