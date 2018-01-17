class StaticController < ApplicationController
  def index
    @body_class = 'pushable landing-page'
    @title = "Welcome to #{@app_name}"
    @hero_description = 'Discover vegan options at restaurants!'
    load_html_title('home')
  end

  def about
    @title = "About #{@app_name}"
    load_html_title('about')
    load_html_description(about_description)
  end

  def sitemap
    redirect_to 'https://menuberry.s3.amazonaws.com/sitemaps/sitemap.xml.gz'
  end

  def privacy_policy
    @title = "Privacy Policy"
    load_html_title('privacy policy')
    load_html_description(privacy_policy_description)
  end

  def terms
    @title = "Terms and Conditions"
    load_html_title('terms and conditions')
    load_html_description(terms_description)
  end

  private

  def about_description
    "#{@app_name} only shows you food items that contain no animal products at a restaurant."
  end

  def privacy_policy_description
    "Detailed outline of the Privacy Policy used by #{@app_name}"
  end
  def terms_description
    "Detailed outline of the Terms and Conditions required to use #{@app_name}"
  end
end
