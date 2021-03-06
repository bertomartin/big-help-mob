class UserStatistics

  UserLocation = Struct.new(:postcode, :lat, :lng, :count)
  UserAgeData  = Struct.new(:data, :min_age, :max_age, :window_min, :window_max, :mean, :count)

  attr_reader :target

  def initialize(target = User)
    @target = target
  end

  def self.for_all_users
    @for_all_users ||= self.new
  end

  class << self
    delegate :signups_per_day, :count_per_volunteering_history, :count_per_volunteering_history_for_subscribers,
             :count_per_gender, :count_per_age, :user_locations, :user_origins, :to => :for_all_users
  end

  def signups_per_day(from = Date.today - 6, to = Date.today)
    from, to = from.to_date, to.to_date
    scope = target.where(["users.created_at > ? AND users.created_at < ?", from.beginning_of_day, to.beginning_of_day])
    counts = normalize_dates scope.count(:all, :group => "DATE(users.created_at)")
    results = ActiveSupport::OrderedHash.new
    while from <= to
      results[from] = counts[from].to_i
      from += 1
    end
    results
  end

  def count_per_volunteering_history
    except_nils! target.count_on_volunteering_history_by_name
  end

  def count_per_volunteering_history_for_subscribers
    except_nils! Subscriber.count_on_volunteering_history_by_name
  end

  def count_per_gender
    except_nils! target.count_on_gender_by_name
  end

  def count_per_age
    relationship = target.where("date_of_birth IS NOT NULL")
    raw_counts   = relationship.count :all, :group => User::AGE_SQL
    known_ages   = raw_counts.keys.map { |k| k.to_i }.reject { |a| a < 1 }.sort # Cut out invalid dates.
    min, max     = known_ages.min.to_i, known_ages.max.to_i
    data         = ActiveSupport::OrderedHash.new(0).tap do |h|
      min.upto(max) { |c| h[c.to_i] = raw_counts[c.to_s].to_i }
    end
    sum_of_ages = data.map { |k, v| k * v }.sum(0)
    num_of_ages = [data.values.sum(0), 1].max
    mean_age    = sum_of_ages.to_f / num_of_ages
    std_dev     = Math.sqrt(data.sum { |k, v| ((k - mean_age) ** 2) * v }.to_f / num_of_ages) * 4
    offset      = [std_dev, 10].max
    min_age     = (mean_age - offset).floor
    max_age     = (mean_age + offset).ceil
    UserAgeData.new(data, min, max, min_age, max_age, mean_age.round, num_of_ages)
  end

  def user_locations
    scope  = target.where("postcode IS NOT NULL AND postcode_lat IS NOT NULL AND postcode_lng IS NOT NULL")
    scope  = scope.select("COUNT(*) as count_all, postcode, postcode_lat, postcode_lng").group("postcode, postcode_lat, postcode_lng")
    scope.all.map do |result|
      UserLocation.new("%04d" % result.postcode, result.postcode_lat, result.postcode_lng, result.count_all.to_i)
    end.sort_by { |r| -r.count }
  end

  def user_origins
    counts = target.count :all, :group => "origin"
    graph_stats = ActiveSupport::OrderedHash.new(0)
    blank_origins = counts.keys.select { |k| k.blank? }
    graph_stats["Unknown Origin"] = blank_origins.map { |v| counts.delete(v).to_i }.sum
    User::ORIGIN_CHOICES.each do |origin|
      graph_stats[origin] = counts.delete(origin).to_i
    end
    graph_stats["Other"] += counts.map { |k, v| v }.sum
    return graph_stats, counts.sort_by { |l, v| -v }
  end

  protected

  def normalize_dates(collection)
    collection.inject({}) do |acc, (k, v)|
      acc[k.to_date] = v
      acc
    end
  end

  def except_nils!(c)
    value = c.tap { |v| v.delete nil }
    if value.blank?
      return "Unknown" => 1
    else
      value
    end
  end

end
