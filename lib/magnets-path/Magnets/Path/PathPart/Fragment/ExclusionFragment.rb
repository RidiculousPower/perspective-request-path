
class ::Magnets::Path::PathPart::Fragment::ExclusionFragment

  include ::Magnets::Path::PathPart::Fragment

	################
	#  initialize  #
	################
	
	def initialize( path_fragment_or_descriptor )
    
    case path_fragment_or_descriptor
    
      when ::Magnets::Path::PathPart::Fragment
    
        @excluded_part = path_fragment_or_descriptor
      
      else
      
        @excluded_part = ::Magnets::Path::PathPart::Fragment.new( path_fragment_or_descriptor )
      
    end
    
	end

	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  matched = false
	  
	  if @excluded_part.match( request_path )

	    request_path.match_failed!
      
    else

	    request_path.matched_fragment!

  	  matched = true

	  end
	  
	  return matched
	  
  end

end
