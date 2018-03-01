# require 'net/http'

class SocialHook
  def initialize(resource)
    @resource = resource
  end

  def notify
    uri = URI('http://twitter-marketing.herokuapp.com/tweets/new')
    # uri = URI('http://localhost:4567/tweets/new')
    class_name = @resource.class.name.downcase.to_sym

    http = Net::HTTP.new(uri.host, uri.port)

    # puts Net::HTTP.post_form(uri, content: messages[class_name] )
    content = { token: ENV['TWEET_WEBHOOK_TOKEN'], content: messages[class_name] }

    json_headers = {"Content-Type" => "application/json",
                    "Accept" => "application/json"}
    # http = Net::HTTP.new('http://twitter-marketing.herokuapp.com')
    # http.use_ssl = true

    # request = Net::HTTP::Post.new('/tweets/new', {'Content-Type' => 'application/json'})
    # request.body = {content: messages[class_name]}

    http.post(uri.path, content.to_json, json_headers)
  end

  def messages
    {
      restaurant: "#{prefix}#{@resource.name} was just added to the app!  Add additional vegan options and restaurants to help inform others! #{ENV['HOST_NAME']}/restaurants/#{@resource.slug} #vegan #veganfood #veganoptions"
    }
  end

  def prefix
    items = non_beverage_items

    return '' if items.empty?

    new_item = items.first.name

    "The #{new_item} at "
  end

  def non_beverage_items
    @resource.items - @resource.items.beverage
  end
end
