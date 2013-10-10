
require_relative 'resource_file'
require_relative 'crc'

require_relative 'list_command'
require_relative 'verify_command'
require_relative 'dump_command'

module FuturoCube
  class ResourceTool
    COMMANDS = {
      'list' => ListCommand.new,
      'verify' => VerifyCommand.new,
      'dump' => DumpCommand.new
    }

    def usage(exit_code = 1)
      $stderr.puts("Usage:")
      COMMANDS.each_pair do |name, command|
        $stderr.puts("  #{$0} #{name} #{command.usage}")
      end
      exit exit_code
    end

    def main(args)
      usage if args.length < 1
      usage(0) if args[0] == '--help'

      command = COMMANDS[args[0]]
      usage if !command

      command_args = args.slice(1..-1)
      usage if !command.args_valid?(command_args)
      command.exec(*command_args)
    end
  end
end
