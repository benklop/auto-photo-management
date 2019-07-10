# frozen_string_literal: true

module PhotoManagement
  class Folder
    class << self
      # look for registered file types in folder
      def scan(folder, extension = 'xmp')
        files = []

        Dir.each_child(folder) do |child|
          fname = File.join(folder, child)
          files.push(scan(fname)).flatten! if File.directory?(fname)
          files.push(fname) if File.file?(fname)
        end

        files.select { |file| File.extname(file).downcase == '.' + extension }
      end

      # monitor for changed registered files in folder, execute the block.
      def watch(folder)
      end
    end
  end

  class Job
    # A job is a folder with a date in the name and at least one of JPG/JPEG/RAW/PROCESSED or a RAW extension
    def initialize()
    end
  end
end
