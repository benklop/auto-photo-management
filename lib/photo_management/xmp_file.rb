module PhotoManagement
  class XMPFile
    NAMESPACES = {
      'rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      'darktable' => 'http://darktable.sf.net/',
      'xmpMM' => 'http://ns.adobe.com/xap/1.0/mm/'
    }.freeze
    COLORS = {
      '0': :red,
      '1': :yellow,
      '2': :green,
      '3': :blue,
      '4': :magenta
    }.freeze
    attr_reader :xmp
    attr_reader :file_name

    def initialize(xmp_file)
      raise "#{xmp_file} is not an XMP file!" unless File.extname(xmp_file).downcase == 'xmp'

      @xmp = File.open(xmp_file) { |f| Nokogiri::XML(f) }
      @file_name = xmp_file
    end

    def type
      return :darktable if @xmp.at_xpath('//rdf:Description', NAMESPACES).namespaces.include? 'xmlns:darktable'
      false
    end

    def ready_for_rendering?
      colors.any? { |color| color == :green }
    end

    def for_personal_use?
      colors.none? { |color| color == :blue }
    end

    def source_file_name
      @xmp.at_xpath('//rdf:Description/@xmpMM:DerivedFrom', NAMESPACES).value
    end

    def updated_at
      File.mtime(file_name)
    end

    def colors
      @xmp.xpath('//darktable:colorlabels//rdf:li', NAMESPACES).map { |item| COLORS[item.content] }
    end
  end
end
