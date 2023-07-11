class StaticPagesController < ApplicationController
  def index
    require 'flickr' # https://github.com/cyclotron3k/flickr
    flickr = Flickr.new

    @user_nsid = lookup_username_or_nsid(form_params[:username_or_nsid], flickr)

    if @user_nsid
      user_public_photos = flickr.people.getPublicPhotos(user_id: @user_nsid)
      @feed_urls = user_public_photos.map { |photo| Flickr.url_m(photo) }
    end
  end

  private

  def lookup_username_or_nsid(user_id_string, flickr)
    return unless user_id_string

    # Try nsid lookup
    begin
      flickr.people.getInfo(user_id: user_id_string)
    # rescue Flickr::FailedResponse
    rescue Exception => e
    puts e
    else
      return user_id_string
    end

    # Try username lookup
    begin
      user = flickr.people.findByUsername(username: user_id_string)
    # rescue Flickr::FailedResponse
    rescue Exception => e
      puts e
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


    # flickr.people.findByUsername
    # flickr.people.findByUsername(username: '198780121@N08')
    # flickr.people.getInfo(user_id: '198780121@N08')

    # @test_username = flickr.people.findByUsername(username: '198780121@N08')

    # begin
    #   @user_public_photos = flickr.people.getPublicPhotos(user_id: form_params[:username_or_nsid])
    # rescue Flickr::FailedResponse
    #   user_id = flickr.people.findByUsername(username: form_params[:username_or_nsid])
    #   @user_public_photos = flickr.people.getPublicPhotos(user_id: user_id)
    # else
    #   @feed_urls = @user_public_photos.map { |photo| Flickr.url_m(photo) }
    # end