class Api::EntriesController < ActionController::API
  before_action :set_entry, only: [:destroy]
  before_action -> { @entries = Entry.unread.by_date }, only: [:index, :pods]

  def index
    render json: @entries.articles
  end

  def destroy
    @entry.update!(read: true)
  end

  def pods
    render json: @entries.pods
  end

  def history
    history = History.last || History.new

    render json: history
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end
end
