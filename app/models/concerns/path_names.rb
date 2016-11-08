module PathNames
  extend ActiveSupport::Concern

  def path_name
    name.gsub(/\s+/, '').underscore
  end
end
# ADD this to the Restaurant model and then test for it