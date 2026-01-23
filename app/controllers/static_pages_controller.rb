class StaticPagesController < ApplicationController
  allow_unauthenticated_access(only: [ :about ])
  def about
    @currently_reading = GoodreadsService.currently_reading
    @recently_read = GoodreadsService.recently_read
  end
end
