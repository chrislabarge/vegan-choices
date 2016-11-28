module PathNames
  extend ActiveSupport::Concern

  def path_name(name = nil)
    name ||= self.name

    return unless name

    name.gsub(/\s+|\W/, '')
    name.underscore
  end

  def image_path
    validate_method_definition(:image_path_suffix)
    path = image_file_path

    return '#' unless (found_path = find_file_path(path))

    format_img_path(found_path)
  end

  def image_path_prefix
    'app/assets/images/'
  end

  private

  def validate_method_definition(method)
    raise Error::UndefinedMethod.new(self, method) unless respond_to?(method)
  end

  def image_file_path # add name to this method name, to make it clearer
    image_file_name = try(:image_file_name) || path_name

    image_path_prefix + image_path_suffix + image_file_name + '*'
  end

  def find_file_path(file_path)
    paths = Dir[file_path]

    return paths[0] unless paths.empty?
    nil
  end

  def format_img_path(file_path)
    file_path.sub(image_path_prefix, '')
  end

  def image_dir(image_path_suffix = nil)
    image_path_suffix ||= self.image_path_suffix
    image_path_prefix + image_path_suffix
  end

  def no_image_file_notification
    return unless image_path == '#'

    notification = "Warning: There was no associated image file found for the #{self.class.name} model with id:#{id}"

    logger.warn notification
    puts notification
  end
end
