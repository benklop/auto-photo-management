require 'open3'

module PhotoManagement
  class Darktable
    class << self
      def render(xmp_file, raw_file, jpeg_file, overwrite=true)
        cmd = "darktable-cli #{raw_file} #{xmp_file} #{jpeg_file} #{overwrite ? '--overwrite' : ''}"
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          puts stdout
        end
      end
    end
  end
end
