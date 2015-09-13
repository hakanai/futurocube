#
# Settings adjusted in VOICEROID+ before running:
#   - End pause: 100ms   (stops popping sounds at the end)
#

require 'fileutils'

VOICEROIDEX_EXE = File.expand_path('~/Documents/GitHub/VoiceroidEx/VoiceroidEx/bin/Debug/VoiceroidEx.exe')
OUTPUT_DIR = File.join(File.expand_path(File.dirname(__FILE__)), 'output')

FileUtils.mkdir_p(OUTPUT_DIR)

File.readlines('script.txt', encoding: 'UTF-8').each do |line|
  line.chomp!.strip!
  next if line =~ /^#/
  if line =~ /^(.*?)\s+=\s+(.*?)$/
    filename = $1
    text = $2

    # Workaround for VOICEROID+ bug, can't handle multiple saves going at once.
    sleep 1

    if !system(VOICEROIDEX_EXE, text, File.join(OUTPUT_DIR, filename).gsub('/', "\\"))
      raise "Failed for line: #{line}"
    end
  end
end
