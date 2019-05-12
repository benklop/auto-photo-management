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
    end

    def rendered?
    end

    def needs_rendering?
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
  end

  class RawFile
  end

end
