class AppSetupController < ApplicationController
  def create
  end

  def edit
  end

  def delete
  end
 
  def save_record
    respond_to do |format|
      format.js
    end
  end

  def test_Conn
    respond_to do |format|
      format.js
    end
  end  
  
end
