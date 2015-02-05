# This module defines the CMS subscription callbacks.
# The callbacks are included in a model that calls #subscribe_me_using.
module CampaignMonitorSubscriber
  module SubscriptionHooks

    extend ActiveSupport::Concern

    included do

      after_create(callback_conditionals) do |record|
        create_subscriber
      end

      after_destroy(callback_conditionals) do |record|
        destroy_subscriber
      end

    end
  end
end
