class StreamsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_stream, only: %i[ show edit update destroy dashboard ]
  before_action :authorize_owner!, only: [:dashboard]

  # GET /streams or /streams.json
  def index
    @streams = Stream.all
  end

  # GET /streams/1 or /streams/1.json
  def show
  end

  def dashboard
  end

  # GET /streams/new
  def new
    @stream = current_user.streams.new
  end

  # GET /streams/1/edit
  def edit
  end

  # POST /streams or /streams.json
  def create
    @stream = current_user.streams.new(stream_params)

    respond_to do |format|
      if @stream.save
        format.html { redirect_to stream_url(@stream), notice: "Stream was successfully created." }
        format.json { render :show, status: :created, location: @stream }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /streams/1 or /streams/1.json
  def update
    respond_to do |format|
      if @stream.update(stream_params)
        format.html { redirect_to stream_url(@stream), notice: "Stream was successfully updated." }
        format.json { render :show, status: :ok, location: @stream }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streams/1 or /streams/1.json
  def destroy
    @stream.destroy!

    respond_to do |format|
      format.html { redirect_to streams_url, notice: "Stream was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def authorize_owner!
      if current_user != @stream.user
        redirect_to root_path, alert: "Sorry you are not authorized to view this page"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_stream
      @stream = Stream.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stream_params
      params.require(:stream).permit(:user_id, :name)
    end
end
