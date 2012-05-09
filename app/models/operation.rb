class Operation < ActiveRecord::Base
  attr_accessible :user_id, :house_id, :subhouse_id, :kind, :content, :date, :time
end
