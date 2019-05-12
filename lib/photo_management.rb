#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'

module PhotoManagement
  class Photo
    attr_reader :jpeg
    attr_reader :raw
    attr_reader :xmp

    def initialize(xmp_file, relative_render_folder = '../processed')
      @xmp = XMPFile(xmp_file)
      @jpeg = JpegFile(
        File.join(
          File.dirname(xmp.file_name),
          relative_render_folder,
          File.basename(xmp.file_name, '.*') + '.jpg'
        )
      )
      @raw = RawFile(
        File.join(
          File.dirname(xmp.file_name),
          xmp.source_file_name
        )
      )
    end

    def rendered?
      jpeg.exist?
    end

    def needs_rendering?
      xmp.updated_at > jpeg.updated_at
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
