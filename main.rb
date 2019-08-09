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


svg = Victor::SVG.new width: 140, height: 100, style: { background: '#ddd' }
svg.build do 
  rect x: 10, y: 10, width: 120, height: 80, rx: 10, fill: '#666'
  circle cx: 50, cy: 50, r: 30, fill: 'yellow'
  circle cx: 58, cy: 32, r: 4, fill: 'black'
  polygon points: %w[45,50 80,30 80,70], fill: '#666'

  3.times do |i|
    x = 80 + i*18
    circle cx: x, cy: 50, r: 4, fill: 'yellow'
  end
end

puts svg.render
