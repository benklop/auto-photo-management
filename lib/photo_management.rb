require 'nokogiri'
require_relative 'photo_management/xmp_file'
require_relative 'photo_management/darktable'

module PhotoManagement
  class Photo
    attr_reader :jpeg
    attr_reader :raw
    attr_reader :xmp
    attr_reader :renderer

    def initialize(xmp_file, relative_render_folder = '../processed')

      @xmp = XMPFile.new(xmp_file)

      @jpeg = JpegFile.new(
        File.join(
          File.dirname(xmp.file_name),
          relative_render_folder,
          File.basename(xmp.file_name, '.*') + '.jpg'
        )
      )

      @raw = RawFile.new(
        File.join(
          File.dirname(xmp.file_name),
          xmp.source_file_name
        )
      )

      @renderer = Darktable if xmp.type == :darktable
    end

    def rendered?
      jpeg.exist?
    end

    def needs_rendering?
      xmp.tagged_ready_for_rendering? && xmp.updated_at > jpeg.updated_at
    end

    def render
      renderer.render(xmp.file_name, raw.file_name, jpeg.file_name)
    end
  end

  class JpegFile
    attr_reader :file_name

    def initialize(jpeg_file)
      @file_name = jpeg_file
    end

    def exist?
      File.exist? file_name
    end

    def updated_at
      return false unless exist?

      File.mtime(file_name)
    end

    def link_to(folder)
      folder_name = PhotoManagement::Config.config[folder]

      #need to determine folder structure differently, as per processed_linker.sh
      dest_name = File.join(folder_name,File.basename(file_name))

      File.unlink(dest_name) if File.exist?(dest_name)
      File.link(dest_name, file_name)

    end
  end

  class RawFile
    attr_reader :file_name

    def initialize(raw_file)
      @file_name = raw_file
    end

    def exist?
      File.exist? file_name
    end
  end
end
