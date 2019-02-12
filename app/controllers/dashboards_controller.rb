class DashboardsController < ApplicationController
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy]

  
  def index
    # @test1 = Dashboard.dlp    
   # @dlp_complex = Dashboard.where('rdd_attribute = "dlp_complex_objects"').order('created_at DESC').last.rdd_value
   
   @test2 = Dashboard.chron
   @chron_collections = Dashboard.where('rdd_attribute = "chron_collections"').order('created_at DESC').last.rdd_value
   #byebug

  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
  end
  
  def create
    @dashboard = Dashboard.new(dashboard_params)

    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to @dashboard, notice: 'Dashboard was successfully created.' }
        format.json { render :show, status: :created, location: @dashboard }
      else
        format.html { render :new }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
      @dashboard = Dashboard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
      params.require(:dashboard).permit(:rdd_attribute, :rdd_value)
    end
end
