#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative 'resource_file'
require_relative 'crc'

def list(file)
  ResourceFile.open(file) do |rf|
    rf.records.each do |rec|
      puts "#{rec.name.ljust(20)}   #{rec.data_length.to_s.rjust(10)}"
    end
  end
end

def verify(file)
  ResourceFile.open(file) do |rf|
    expected = rf.header.checksum
    progress = nil
    actual = rf.compute_checksum do |done, total|
      progress ||= ProgressBar.new("Checking", total)
      progress.set(done)
    end
    progress.finish

    if actual == expected
      puts "  Checksum %08X OK" % [actual]
    else
      puts "  Checksum %08X NG (expected %08X)" % [actual, expected]
    end
  end
end

def dump(file, dir)
  ResourceFile.open(file) do |rf|
    progress = ProgressBar.new("Dumping", rf.records.size)
    rf.records.each do |rec|
      data = rf.data(rec)

      f = File.join(dir, "#{rec.name}.wav")
      format = WaveFile::Format.new(:mono, :pcm_16, 22050)
      WaveFile::Writer.new(f, format) do |writer|
        #TODO: is there a way to write a buffer directly?
        samples = data.unpack("S<#{rec.data_length/2}")
        buffer = WaveFile::Buffer.new(samples, format)
        writer.write(buffer)
      end

      progress.inc
    end
    progress.finish
  end
end

def usage(exit_code = 1)
  $stderr.puts("Usage:")
  $stderr.puts("  #{$0} list filename")
  $stderr.puts("  #{$0} verify filename")
  $stderr.puts("  #{$0} dump filename directory")
  exit exit_code
end

def main(args)
  if args.length < 1
    usage
  end

  case args[0]
  when '--help'
    usage(0)
  when 'list'
    usage if args.length < 2
    list(args[1])
  when 'verify'
    usage if args.length < 2
    verify(args[1])
  when 'dump'
    usage if args.length < 3
    dump(args[1], args[2])
  else
    usage
  end
end

if $0 == __FILE__
  main(ARGV)
end
