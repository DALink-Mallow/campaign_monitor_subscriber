# This module defines the CMS subscription callbacks.
# The callbacks are included in a model that calls #subscribe_me_using.
module CampaignMonitorSubscriber
  module SubscriptionHooks

    extend ActiveSupport::Concern

    included do

      after_create do |record|
        CreateSend::Subscriber.add(
          cms_config.list_id,
          record.cms_email,
          record.cms_name,
          [record.cms_custom_fields],
          true
        )
      end


      after_destroy do |record|
        s = CreateSend::Subscriber.new(
          cms_config.list_id,
          record.cms_email
        )
        s.unsubscribe
      end

    end
  end
end
