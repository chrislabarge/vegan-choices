require 'active_model_serializers'
ActiveModelSerializers.config.adapter = :json
ActiveModelSerializers.config.key_transform = :camel_lower
