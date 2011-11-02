module Meatloaf
  def to_meatloaf
    "IT MEATS"
  end
end

class ActiveRecord::Base
  include Meatloaf
end

