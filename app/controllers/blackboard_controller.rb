class BlackboardController < ApplicationController

  # The root path / homepage.
  def show
    @groups = Group.all
  end

end
