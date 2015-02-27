require 'json'
require 'rein'
DEFAULT_COLOR = "FFFFFF"
class Json_attribute
  attr_accessor :attr, :value, :color
  def initialize (attr, value)
    @attr = attr
    @value = value
    @rule = Rein::RuleEngine.new 'json_rules.yaml'
    @color="FFFFFF"
    self.run_rule
  end 
  def run_rule
    @rule.fire self
  end
end

def to_html(html, div, data, new_line = true)
  html << '<table border=1 style=\"width:100%\">'
  klass = data.class
  div_incoming = div.dup
  case
  when klass == Hash
    data.each do |key, value|
      if new_line == true then
      html << "<tr>"
      end
      html << "<th>#{key}</th>"
      if value.class == Hash then
        div << ".#{key}"
        html << "<td>"
        html, new_line =   to_html(html, div, value, true)  
        html << "</td>"
        div = div_incoming.dup
      elsif value.class == Array then
        html << "<td>"
        value.each do |arr_data|
          div << ".#{key}"
          html, new_line =   to_html(html, div, arr_data, true) 
          div = div_incoming.dup
        end
        html << "</td>"
      else
          div << ".#{key}"
           json_attr=Json_attribute.new("#{div}","#{value}")
           html << "<td width=\"70%\" title=\"#{div}\" div=\"#{div}\" bgcolor=\"#{json_attr.color}\">#{value}</td>"
           div = div_incoming.dup
           
      end
            if new_line == true then
      html << "</tr>"
      end
    end
  end
  html << '</table>'
  return html, new_line
end


json= File.read('json.txt')



json_parse = JSON.parse(json)
#json_parse={"id"=>"3", "title"=>"121212", "description"=>"121212", "image_url"=>"1234", "price"=>"123452.0", "created_at"=>"2015-02-21T00:03:26.560Z", "updated_at"=>"2015-02-21T00:03:26.560Z"}

#puts json_parse
hash = json_parse
#puts hash.to_s
html = '<table>'
div = ""
html, new_line = to_html(html, div, hash)
html << '</table>'

#puts html
File.open('test.html', 'w') { |file| file.write("#{html}") }