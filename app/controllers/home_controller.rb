class HomeController < ApplicationController
  def index
    
  end
  def json_to_html
    respond_to do |format|
      format.js
    end
  end
  def to_html
    @hash = JSON.parse(params[:json])
    @html = '<table>'
    @div = ""
    html, new_line = process_json(@html, @div, @hash)
    html << '</table>'
    respond_to do |format|
      format.json { render :json => {:status => "200", :html => html}.to_json }
    end
  end 
  
  
  def process_json(html, div, data, new_line = true)
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
        html, new_line =   process_json(html, div, value, true)  
        html << "</td>"
        div = div_incoming.dup
      elsif value.class == Array then
        html << "<td>"
        value.each do |arr_data|
          div << ".#{key}"
          html, new_line =   process_json(html, div, arr_data, true) 
          div = div_incoming.dup
        end
        html << "</td>"
      else
          div << ".#{key}"
           #json_attr=Json_attribute.new("#{div}","#{value}")
           html << "<td width=\"70%\" title=\"#{div}\" div=\"#{div}\" bgcolor=\"FFFFFF\">#{value}</td>"
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

end
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

