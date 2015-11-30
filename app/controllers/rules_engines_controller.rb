class RulesEnginesController < ApplicationController
  before_action :set_rules_engine, only: [:show, :edit, :update, :destroy]
  # GET /rules_engines
  # GET /rules_engines.json
  def index
    @rules_engines = RulesEngine.all
  end

  # GET /rules_engines/1
  # GET /rules_engines/1.json
  def show
  end

  # GET /rules_engines/new
  def new
    @rules_engine = RulesEngine.new
  end

  # GET /rules_engines/1/edit
  def edit
  end

  # POST /rules_engines
  # POST /rules_engines.json
  def create
    @rules_engine = RulesEngine.new(rules_engine_params)

    respond_to do |format|
      if @rules_engine.save
        format.html { redirect_to @rules_engine, notice: 'Rules engine was successfully created.' }
        format.json { render :show, status: :created, location: @rules_engine }
      else
        format.html { render :new }
        format.json { render json: @rules_engine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rules_engines/1
  # PATCH/PUT /rules_engines/1.json
  def update
    respond_to do |format|
      if @rules_engine.update(rules_engine_params)
        format.html { redirect_to @rules_engine, notice: 'Rules engine was successfully updated.' }
        format.json { render :show, status: :ok, location: @rules_engine }
      else
        format.html { render :edit }
        format.json { render json: @rules_engine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rules_engines/1
  # DELETE /rules_engines/1.json
  def destroy
    @rules_engine.destroy
    respond_to do |format|
      format.html { redirect_to rules_engines_url, notice: 'Rules engine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def search
    if params[:q].nil?
      @rules_engines = []
    else
      @rules_engines = RulesEngine.search params[:q]
    end
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rules_engine
    @rules_engine = RulesEngine.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rules_engine_params
    params.require(:rules_engine).permit(:name, :json_attribute, :operator, :value, :color)
  end


end
