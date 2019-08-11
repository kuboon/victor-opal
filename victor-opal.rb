require 'victor'

module Victor
  class Attributes

    # Opal is not compatible with String#encode(xml: :attr)
    def to_s
      mapped = attributes.map do |key, value|
        key = key.to_s.tr '_', '-'

        if value.is_a? Hash
          style = Attributes.new(value).to_style
          "#{key}=\"#{style}\""
        elsif value.is_a? Array
          "#{key}=\"#{value.join ' '}\""
        else
          "#{key}=#{xml_escape(value)}"
        end
      end

      mapped.join ' '
    end
    def xml_escape(value)
      "\"#{value.to_s}\""
    end
  end

  class SVGBase

    # Opal doesn't have File.read. Return default.svg instead.
    def svg_template
      <<-EOS
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg %{attributes} 
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink">

%{style}
%{content}

</svg>
EOS
    end
  end
end

require 'opal-parser'

