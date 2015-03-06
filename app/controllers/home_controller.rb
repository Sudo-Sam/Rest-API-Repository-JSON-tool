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
    @html = '<table class = "result_table">'
    @error_table = '<table class = "result_table">'
    @div = ""
    @error_table, @html, new_line = process_json(@error_table, @html, @div, @hash)
    @html << '</table>'
    @error_table << '</table>'
    respond_to do |format|
      format.json { render :json => {:status => "200", :html => @html, :error_table => @error_table}.to_json }
    end
  end 
  
  
  def process_json(error_table, html, div, data, new_line = true)
  html << '<table class = "result_table">'
  klass = data.class
  div_incoming = div.dup
  case
  when klass == Hash
    data.each do |key, value|
      if new_line == true then
      html << "<tr class = \"result_table\">"
      end
      html << "<th class = \"result_table\">#{key}</th>"
      if value.class == Hash then
        div << ".#{key}"
        html << "<td class = \"result_table\">"
        error_table, html, new_line =   process_json(error_table, html, div, value, true)  
        html << "</td>"
        div = div_incoming.dup
      elsif value.class == Array then
        html << "<td class = \"result_table\">"
        value.each do |arr_data|
          div << ".#{key}"
          error_table, html, new_line =   process_json(error_table, html, div, arr_data, true) 
          div = div_incoming.dup
        end
        html << "</td>"
      else
          div << ".#{key}"
           json_attr=Json_attribute.new("#{div}","#{value}")
           if  json_attr.color != "FFFFFF" then
             error_table << "<tr class = \"result_table\">"
             error_table << "<th class = \"result_table\">#{div}</th>"
             error_table << "<td class = \"result_table\" id=\"#{div}\" title=\"#{div}\" onclick = \"someFunction('one')\" bgcolor=\"#{json_attr.color}\">#{value}</td>"
             error_table << "</tr>"
           end
           html << "<td class = \"result_table\" id=\"#{div}\" title=\"#{div}\" onclick = \"someFunction('one')\" bgcolor=\"#{json_attr.color}\">#{value}</td>"
           div = div_incoming.dup
           
      end
            if new_line == true then
      html << "</tr>"
      end
    end
  end
  html << '</table>'
  return error_table ,html, new_line
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

