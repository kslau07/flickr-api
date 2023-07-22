class StaticPagesController < ApplicationController
  def index
    require 'flickr' # https://github.com/cyclotron3k/flickr
    flickr = Flickr.new

    @user_nsid = lookup_username_or_nsid(form_params[:username_or_nsid], flickr)

    rand_amt = rand(25..33)
    
    if @user_nsid
      user_public_photos = flickr.people.getPhotos(user_id: @user_nsid, per_page: rand_amt)
      @feed_urls = user_public_photos.map { |photo| Flickr.url_m(photo) }
    end
  end

  private

  def lookup_username_or_nsid(user_id_string, flickr)
    return unless user_id_string

    # Try nsid lookup
    begin
      flickr.people.getInfo(user_id: user_id_string)
    rescue Flickr::FailedResponse
    else
      return user_id_string
    end

    # Try username lookup
    begin
      user = flickr.people.findByUsername(username: user_id_string)
    rescue Flickr::FailedResponse
    else
      return user.nsid
    end

    # If cannot find user, return nil
    nil
  end

  def form_params
    params.permit(:username_or_nsid)
  end
end
