
class ::Magnets::Path::PathPart::Regexp

  include ::Magnets::Path::PathPart

	################
	#  initialize  #
	################
	
	def initialize( regexp_or_source )

    case regexp_or_source
      
      when ::Regexp

        @regexp = regexp_or_source
      
      when ::String
        
        @regexp = ::Regexp.new( regexp_or_source )
        
      else
      
        raise ::ArgumentError, 'Expected Regexp or String regexp source.'
      
    end

	end
	
	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  matched = false
	  
	  if @regexp.match( request_path.current_part )

	    request_path.matched_part!

  	  matched = true
  	  
  	else
  	  
  	  request_path.match_failed!

	  end
	  
	  return matched
	  
  end

end
