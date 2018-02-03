# AWS Setup
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                                                    aws_access_key_id: ENV['AWS_KEY_ID'],
                                                                    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
                                                                    fog_directory: ENV['AWS_DIR'],
                                                                    fog_region: ENV['AWS_REGION']
                                                                    )

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = ENV['AWS_HOST']
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV['HOST_NAME']


SitemapGenerator::Sitemap.ping_search_engines( ENV['HOST_NAME'] + '/sitemap')

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  add root_path, :changefreq => 'weekly'
  add about_path, :changefreq => 'monthly'
  add new_contact_path, :changefreq => 'monthly'
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  #
  # Add '/articles'
  #
  add restaurants_path(sort_by: 'content_berries'), :priority => 0.9, :changefreq => 'weekly'
  #
  # Add new restaurant path

  add new_restaurant_path, :priority => 0.5, :changefreq => 'weekly'

  # Add all Items:

  Item.find_each do |item|
    add item_path(item), :lastmod => item.updated_at, changefreq: 'weekly'
  end
  # Add all Users:

  User.find_each do |user|
    add user_path(user), :lastmod => user.updated_at, changefreq: 'weekly'
  end
  # Add all Restaurants:

  Restaurant.find_each do |restaurant|
    add restaurant_path(restaurant.slug), :lastmod => restaurant.updated_at, changefreq: 'weekly'
  end
end
