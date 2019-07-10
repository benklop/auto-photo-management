# frozen_string_literal: true

module PhotoManagement
  class RenderedFile
    attr_reader :file_name
    attr_reader :dir_name
    attr_reader :base_name
    def initialize(file)
      # doing it this way gives us the direct path with no .., even when the last component
      # does not yet exist.
      @dir_name = File.realdirpath(File.dirname(file))
      @base_name = File.basename(file)
      @file_name = File.join(dir_name, base_name)
    end

    def exist?
      File.exist? file_name
    end

    def updated_at
      return Time.new(0) unless exist?

      File.mtime(file_name)
    end

    def link_to(location)
      base_path_name = "/home/benklop/Pictures/Processed"
      # need to determine folder structure differently, as per processed_linker.sh

      dest_name = File.join(base_path_name, File.basename(file_name))

      puts dest_name
      #return if File.identical?(dest_name, src_name)

      #File.unlink(dest_name) if File.exist?(dest_name)
      #File.link(dest_name, src_name)
    end
  end
end
