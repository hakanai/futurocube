require 'wavefile'

require_relative 'resource_file'
require_relative 'command_helper'

module FuturoCube
  class DumpCommand
    include CommandHelper

    def exec(file, dir)
      ResourceFile.open(file) do |rf|
        with_progress('Dumping', rf.records.size) do |progress|
          rf.records.each do |rec|
            data = rf.data(rec)

            f = File.join(dir, "#{rec.name}.wav")
            format = WaveFile::Format.new(:mono, :pcm_16, 22050)
            WaveFile::Writer.new(f, format) do |writer|
              #TODO: is there a way to write a buffer directly?
              samples = data.unpack("S<*")
              buffer = WaveFile::Buffer.new(samples, format)
              writer.write(buffer)
            end

            progress.inc
          end
        end
      end
    end

    def args_valid?(args)
      args.length == 2
    end

    def usage
      "filename directory"
    end
  end
end
