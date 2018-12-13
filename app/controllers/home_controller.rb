class HomeController < ApplicationController
  def index
    @videos = Video.all
    gon.videos = @videos
  end
end

