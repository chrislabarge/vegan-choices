module FeatureHelper
  def given_a_vistor_is_viewing_a(resource, arg)
    return unless (path_prefix = resource.to_s)

    if arg == :index
      arg = nil
      path_prefix = path_prefix.pluralize
    end

    path = path_prefix + '_path'

    visit send(path, arg)
    sleep(1)
  end
end