class Session < ActiveRecord::Base
  def self.sweep(time = 1.hour)
    time = time.split.inject { |count, unit| count.to_i.send(unit) } if time.is_a?(String)
 
    Session.delete_all "updated_at < '#{time.ago.to_s(:db)}'"
  end
end