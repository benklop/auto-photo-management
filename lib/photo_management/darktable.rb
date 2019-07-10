# frozen_string_literal: true

require 'open3'

module PhotoManagement
  class Darktable
    class << self
      def render(xmp_file, raw_file, dest_file, overwrite = true)
        File.unlink(dest_file) if overwrite && File.exist?(dest_file)
        puts "rendering #{dest_file}..."
        cmd = "darktable-cli \"#{raw_file}\" \"#{xmp_file}\" \"#{dest_file}\""
        Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
          puts "running #{cmd}..."
          raise "Darktable error: #{stderr.read}" unless wait_thr.value.to_i.zero?

          puts stdout.read
        end
      end
    end
  end
end
