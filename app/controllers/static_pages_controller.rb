class StaticPagesController < ApplicationController
  def index
    # Build a simple StaticPagesController to display a home page with a simple form.
    # The form should just be a single text field which takes the ID for a Flickr user.
    # Once the form is submitted, the page should refresh and display the photos from that user.

    require 'flickr'          # https://github.com/cyclotron3k/flickr
    flickr = Flickr.new

    # User ID:
    # 198780121@N08

    @feed_photos = flickr.people.getPublicPhotos(user_id: '198780121@N08')
    @feed_urls = @feed_photos.map { |photo| Flickr.url_m(photo) }
  end

  private

  def form_params
    params.permit(:flickr_id)
  end
end
