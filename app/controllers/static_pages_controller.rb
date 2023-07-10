class StaticPagesController < ApplicationController
  def index
    require 'flickr'
    flickr = Flickr.new

    list   = flickr.photos.getRecent
  end
end
