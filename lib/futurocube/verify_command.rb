module FuturoCube
  class VerifyCommand
    def exec(file)
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

    def args_valid?(args)
      args.length == 1
    end

    def usage
      "filename"
    end
  end
end
