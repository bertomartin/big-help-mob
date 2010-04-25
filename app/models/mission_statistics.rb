class MissionStatistics
  
  attr_accessor :mission
  
  def initialize(mission)
    @mission = mission
  end
  
  def participations
    @participations ||= @mission.mission_participations.all(:include => {:role => nil, :user => nil, :pickup => {:pickup => :address}})
  end
  
  def pending_participations
    participations.select { |p| p.still_preparing? }
  end
  
  def approved_participations
    participations.select { |p| p.approved? }
  end
  
  def other_participations
    participations - preparing_participations - approved_participations
  end
  
  def sidekicks(collection = participations)
    collection.select { |c| c.sidekick? }
  end
  
  def captains(collection = participations)
    collection.select { |c| c.captain? }
  end
  
  def approved_sidekicks
    sidekicks approved_participations
  end
  
  def approved_captains
    captains approved_participations
  end
  
  def count(collection = :all, type = :all)
    ps = (collection == :all ? participations : send(:"#{collection}_participations"))
    ps = send(type, ps) unless type == :all
    ps.size
  end
  
  def pickups
    pickups = ActiveSupport::OrderedHash.new
    grouped_sidekicks = approved_sidekicks.group_by { |p| p.pickup_id }
    unordered = @mission.mission_pickups.all(:include => {:pickup => :address})
    unordered.sort_by { |mp| mp.pickup_at }.each do |pickup|
      pickups[pickup] = grouped_sidekicks[pickup.id] || []
    end
    pickups
  end
  
end