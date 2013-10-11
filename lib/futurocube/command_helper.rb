require 'progressbar'

module FuturoCube
  module CommandHelper
    def with_progress(title, total, &block)
      progress = ProgressBar.new(title, total)
      begin
        block.call(progress)
      ensure
        progress.finish
      end
    end
  end
end
