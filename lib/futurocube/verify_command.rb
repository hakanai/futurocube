require_relative 'resource_file'
require_relative 'command_helper'

module FuturoCube
  class VerifyCommand
    include CommandHelper

    def exec(file)
      ResourceFile.open(file) do |rf|
        expected = rf.header.checksum
        actual = with_progress('Checking', rf.header.file_size) do |progress|
          rf.compute_checksum do |done|
            progress.set(done)
          end
        end

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
