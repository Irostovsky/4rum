# ActsAsBlabbermouth# ActsAsBlabbermouth 
module ActiveRecord #:nodoc: 
  module Acts #:nodoc: 
    module Blabbermouth #:nodoc: 
      def self.included(base) 
        base.extend(ClassMethods) 
      end 
 
      module ClassMethods 
        def acts_as_blabbermouth 
          include ActiveRecord::Acts::Blabbermouth::InstanceMethods 
          extend ActiveRecord::Acts::Blabbermouth::SingletonMethods 
        end 
      end 
 
      module SingletonMethods 
        def quote_me        
          quotes = [ 
            "When you come to a fork in the road, take it. -Yogi Berra", 
            "Every child is an artist. The problem is how to remain an artist once he grows up. -Pablo Picasso", 
            "What we anticipate seldom occurs; what we least expected generally happens. -Benjamin Disraeli", 
            "Drive-in banks were established so most of the cars today could see their real owners. -E. Joseph Cossman", 
            "The greatest pleasure in life is doing what people say you cannot do. -Walter Bagehot" 
          ] 
 
          quotes[rand(quotes.size)] 
        end 
      end 
 
      module InstanceMethods 
        def quote_me 
          self.class.quote_me 
        end 
      end 
    end 
  end 
end 
 
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Blabbermouth) 
