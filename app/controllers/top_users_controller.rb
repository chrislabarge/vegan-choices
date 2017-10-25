class TopUsersController < ApplicationController
  def berries
    @title = "Top Users"
    load_html_title('berries')
    load_html_description(berries_description)
    #need to come up with a way better way to query this
    @users = User.all.sort_by(&:berry_count).reverse
  end

  private

  def berries_description
    "A list of the users with the most berries.  Earn berries by adding content."
  end
end
