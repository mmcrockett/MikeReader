class EntriesController < ApplicationController
  before_action :set_entry, only: [:update]

  # GET /entries
  # GET /entries.json
  def index
    if (true == request.format.json?)
      @entries = Entry.articles
    end
  end

  # GET /pods
  # GET /pods.json
  def pods
    if (true == request.format.json?)
      @entries = Entry.pods
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.json { render :show, status: :ok, location: @entry }
      else
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:read)
    end
end
