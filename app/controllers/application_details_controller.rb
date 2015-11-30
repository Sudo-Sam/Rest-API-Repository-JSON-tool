class ApplicationDetailsController < HomeController
  before_action :set_application_detail, only: [:show, :edit, :update, :destroy]
  # GET /application_details
  # GET /application_details.json
  def index
    @application_details = ApplicationDetail.all
  end

  def test_Conn
    @application_detail = ApplicationDetail.new(application_detail_params)
    @html = ''
    @error_table = '<table class="table-striped header-fixed">'
    @div = ""
    payload = @application_detail.request_text
    request_hdr = "{"
    @application_detail.request_hdr.each_line do |keyValue|
      input = keyValue.split(":")
      if request_hdr == "{" then
        request_hdr = "#{request_hdr}\"#{input[0].strip}\" : \"#{input[1].strip}\""
      else
        request_hdr = "#{request_hdr},\"#{input[0].strip}\" : \"#{input[1].strip}\""
      end
    end
    request_hdr = "#{request_hdr}}"
    request_hdr = JSON.parse(request_hdr)
    uri = URI.encode(@application_detail.uri.strip)
    @resp = RestClient::Request.execute(
    :method => @application_detail.rest_method,
    :url => uri,
    :payload => payload,
    :headers=> request_hdr
    )
    @hash = JSON.parse(@resp)
    @error_table, @html, new_line = process_json(@error_table, @html, @div, @hash)
    respond_to do |format|
      format.json { render :json => {:status => "200", :html => @html, :error_table => @error_table}.to_json }
    end
  end

  # GET /application_details/1
  # GET /application_details/1.json
  def show
  end

  # GET /application_details/new
  def new
    @application_detail = ApplicationDetail.new
  end

  # GET /application_details/1/edit
  def edit
  end

  # POST /application_details
  # POST /application_details.json
  def create
    @application_detail = ApplicationDetail.new(application_detail_params)

    respond_to do |format|
      if @application_detail.save
        format.json { render :json => {:status => "200", :html => @html, :error_table => @error_table, :location=> @application_detail.id }.to_json  }
        format.js { return "Success"}
      else
        format.html { render :new }
        format.json { render json: @application_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /application_details/1
  # PATCH/PUT /application_details/1.json
  def update
    respond_to do |format|
      if @application_detail.update(application_detail_params)
        format.html { redirect_to @application_detail, notice: 'Application detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @application_detail }
      else
        format.html { render :edit }
        format.json { render json: @application_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /application_details/1
  # DELETE /application_details/1.json
  def destroy
    @application_detail.destroy
    respond_to do |format|
      format.html { redirect_to application_details_url, notice: 'Rest URI was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  def search
    if params[:q].nil?
      @application_detail = []
    else
      @application_detail = ApplicationDetail.search params[:q]
    end
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application_detail
    @application_detail = ApplicationDetail.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def application_detail_params
    params.require(:application_detail).permit(:name,:uri_name, :environment, :rest_method, :uri, :request_hdr, :request_text)
  end
end
