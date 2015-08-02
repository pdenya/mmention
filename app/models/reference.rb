class Reference < ActiveRecord::Base
  belongs_to :video
  belongs_to :comment
end
