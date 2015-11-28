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
    logger.info params[:app_name]
    @html = ''
    @error_table = '<table class="table-striped header-fixed">'
    @div = ""
    @error_table, @html, new_line = process_json(@error_table, @html, @div, @hash)
    @html << '</table>'
    @error_table << '</table>'
    respond_to do |format|
      format.json { render :json => {:status => "200", :html => @html, :error_table => @error_table}.to_json }
    end
  end 
  
  
  def process_json(error_table, html, div, data, new_line = true)
  html << '<table class="table table-striped table-bordered header-fixed">'
  klass = data.class
  logger.info klass
  div_incoming = div.dup
  case
  when klass == Hash
    data.each do |key, value|
      if new_line == true then
      html << "<tr >"
      end
      html << "<th >#{key}</th>"
      if value.class == Hash then
        div << ".#{key}"
        html << "<td >"
        error_table, html, new_line =   process_json(error_table, html, div, value, true)  
        html << "</td>"
        div = div_incoming.dup
      elsif value.class == Array then
        html << "<td>"
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
             error_table << "<tr >"
             error_table << "<th >#{div}</th>"
             error_table << "<td  id=\"#{div}\" title=\"#{div}\" onclick = \"someFunction('one')\" bgcolor=\"#{json_attr.color}\">#{value}</td>"
             error_table << "</tr>"
           end
           html << "<td  id=\"#{div}\" title=\"#{div}\" >#{value}</td>"
           div = div_incoming.dup
           
      end
      if new_line == true then
        html << "</tr>"
      end
    end
    when klass == Array 
        data.each do |arr_data|
          if new_line == true then
            html << "<tr><th>"
          end
          html << "<td>"
          error_table, html, new_line =   process_json(error_table, html, div, arr_data, true) 
          div = div_incoming.dup
          html << "</td>"
        end
        html << "</td>"
      if new_line == true then
        html << "</th></tr>"
      end
  end
  html << '</table>'
  logger.info html
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

