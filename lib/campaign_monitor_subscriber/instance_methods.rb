# These methosd became instance methods on a model that calls #subscribe_me_using.
# They provide easy access to parsed CMS config values.
module CampaignMonitorSubscriber
  module InstanceMethods
    def cms_custom_fields
      cms_config.custom_fields.map { |k, v| { Key: k, Value: send(v) } }
    end

    def cms_email
      send(cms_config.email_field)
    end

    def cms_name
      cms_config.name_field ? send(cms_config.name_field) : cms_email
    end

    def cms_config
      self.class.cms_config
    end

    def subscriber
      CreateSend::Subscriber.new(
        cms_config.list_id,
        cms_email
      )
    end

    def subscribed?
      CreateSend::Subscriber.get(cms_config.list_id, cms_email).State == 'Active'
      rescue false
    end

    def create_subscriber
      CreateSend::Subscriber.add(
        cms_config.list_id,
        cms_email,
        cms_name,
        cms_custom_fields,
        true
      )
    end

    def destroy_subscriber
      subscriber.unsubscribe
    end

    def update_subscriber
      subscriber.update cms_email, cms_name, cms_custom_fields, true
    end

  end
end
