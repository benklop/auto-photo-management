# frozen_string_literal: true

class RawFile
  attr_reader :file_name

  def initialize(raw_file)
    @file_name = raw_file
  end

  def exist?
    File.exist? file_name
  end
end
