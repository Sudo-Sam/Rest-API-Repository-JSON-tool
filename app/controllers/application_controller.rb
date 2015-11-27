class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
def button_to_with_icon(text, path, classes)
  form_tag path, :method => :post, remote: true do
    button_tag(classes) do
      raw text
    end
  end
end