require_relative 'resource_file'

module FuturoCube
  class ListCommand
    def exec(file)
      ResourceFile.open(file) do |rf|
        rf.records.each do |rec|
          puts "#{rec.name.ljust(20)}   #{rec.data_length.to_s.rjust(10)}"
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
