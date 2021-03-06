class CampaignMonitorWrapper

  @@config ||= nil

  class << self

    def list_options_for_select
      {
        "Subscribe me to the Big Help Mob mailing list" => "default"
      }
    end

    def default_list_id
      Settings.campaign_monitor.default_list.presence
    end

    def list_options
      default = default_list_id
      {
        "default" => default,
        "other"   => (available_list_ids - [default]).compact
      }
    end

    def expand_lists(*args)
      options = list_options
      Array(args.flatten).reject(&:blank?).map do |value|
        options[value.to_s]
      end.compact.flatten.uniq
    end

    def logger
      Rails.logger
    end

    def for_select
      available_lists.map { |k, v| [v, k] }
    end

    def available_lists
      Settings.campaign_monitor.lists.to_hash.stringify_keys
    end

    def available_list_names
      available_lists.values
    end

    def available_list_ids
      available_lists.keys
    end

    def update_subscriptions!(user, lists)
      return false unless has_campaign_monitor?
      lists = Array(lists.flatten).reject { |l| l.blank? } & available_list_ids
      logger.info "Preparing to subscribe #{user.inspect} to #{lists.join(",")}"
      lists.each { |list| subscribe! user, list }
      true
    end

    def update_for_subscriber!(user, lists = :default)
      return false unless has_campaign_monitor?
      user = cm_user_for(user)
      lists = [default_list_id] if lists == :default
      # Subscribe to the lists
      update_subscriptions! user, lists
    end

    def subscribe!(user, list)
      return false unless has_campaign_monitor?
      user.add_and_resubscribe! list if user.present?
      true
    end

    def cm_user_for(subscriber)
      subscriber = subscriber.to_subscriber_details if subscriber.respond_to?(:to_subscriber_details)
      subscriber = subscriber.symbolize_keys
      Campaigning::Subscriber.new(subscriber[:email], subscriber[:name])
    end

    def has_campaign_monitor?
      defined?(Campaigning) && defined?(CAMPAIGN_MONITOR_API_KEY) && CAMPAIGN_MONITOR_API_KEY.present?
    end

    def configure!
      if Settings.campaign_monitor.api_key?
        require 'campaigning'
        Object.const_set :CAMPAIGN_MONITOR_API_KEY, Settings.campaign_monitor.api_key
      end
    end

  end

end
