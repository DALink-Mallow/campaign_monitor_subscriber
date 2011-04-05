module CampaignMonitorSubscriber
  require 'campaigning'
  CM_CONFIG = YAML::load_file(File.join(RAILS_ROOT, "config/campaign_monitor_subscriber_config.yml"))
  ::CAMPAIGN_MONITOR_API_KEY = CM_CONFIG['api_key']  

  def subscribe_me_using(email_field)
    return if CM_CONFIG[RAILS_ENV] == false

    after_create do |record|
      begin
        s = Campaigning::Subscriber.new(record.send(email_field))
        s.add!(cm_list_id)
      rescue RuntimeError
      end
    end

    after_destroy do |record|
      begin
        Campaigning::Subscriber.unsubscribe!(record.send(email_field), cm_list_id)
      rescue RuntimeError
      end
    end
  end

  private
    def cm_list_id
      YAML::load_file(File.join(RAILS_ROOT, "config/campaign_monitor_subscriber_config.yml"))['list_id']
    end
end

ActiveRecord::Base.extend(CampaignMonitorSubscriber)