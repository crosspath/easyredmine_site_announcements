class AnnouncementsController < ApplicationController
  layout "admin"

  respond_to :html, only: :index
  respond_to :js, except: :index

  before_filter :require_admin, except: [:index, :hide, :show]
  before_filter :find_announcement, except: [:hide, :index, :new, :create]

  def hide
    ids = [params[:id], *cookies.signed[:hidden_announcement_ids]]
    cookies.permanent.signed[:hidden_announcement_ids] = ids
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def index
    @announcements = Announcement.order('ends_at DESC')
    respond_with @announcements
  end

  def show
    respond_with @announcement
  end

  def new
    @announcement = Announcement.new
    respond_with @announcement
  end

  def edit
    respond_with @announcement
  end

  def create
    @announcement = Announcement.new params[:announcement]
    @announcement.user = User.current
    if @announcement.save && !request.xhr?
      flash[:notice] = "Announcement was successfully created."
    end
    respond_with @announcement
  end

  def update
    if @announcement.update_attributes(params[:announcement]) && !request.xhr?
      flash[:notice] = "Announcement was successfully updated."
    end
    respond_with @announcement
  end

  def destroy
    @announcement.destroy
    flash[:notice] = "Announcement was successfully deleted." unless request.xhr?
    respond_with @announcement
  end

  private
  def find_announcement
    @announcement = Announcement.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
