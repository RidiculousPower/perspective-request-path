
class ::Magnets::Path::PathPart::Fragment::RegexpFragment

  include ::Magnets::Path::PathPart::Fragment

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
	  
	  if request_path.matched_fragment( self )
	    
	    matched = true
	    
	  elsif matched_fragment = request_path.current_fragment.match( @regexp ) and
	        request_path.current_fragment.start_with?( matched_fragment[ 0 ] )

	    request_path.matched_fragment!( matched_fragment[ 0 ].length )

  	  matched = true

	  end
	  
	  return matched
	  
  end

  ######################
	#  look_ahead_match  #
	######################
	
  def look_ahead_match( request_path )
    
    index = nil
    length = nil
	  
	  if index = ( @regexp =~ request_path.current_fragment )
      
      length = Regexp.last_match.length
      
	    request_path.matched_look_ahead_fragment!( index, length )

	  end
	  
	  return index, length
    
  end
	
end
