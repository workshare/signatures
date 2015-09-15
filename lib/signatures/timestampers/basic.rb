module Signatures
  module Timestampers
    Basic = -> { Time.now.to_i.to_s }
  end
end
