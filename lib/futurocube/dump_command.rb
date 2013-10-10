module FuturoCube
  class DumpCommand
    def exec(file, dir)
      ResourceFile.open(file) do |rf|
        progress = ProgressBar.new("Dumping", rf.records.size)
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
        progress.finish
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
