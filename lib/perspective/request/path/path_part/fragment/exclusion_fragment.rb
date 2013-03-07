# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Fragment::ExclusionFragment

  include ::Perspective::Request::Path::PathPart::Fragment

	################
	#  initialize  #
	################
	
	def initialize( path_fragment_or_descriptor )
    
    case path_fragment_or_descriptor
    
      when ::Perspective::Request::Path::PathPart::Fragment
    
        @excluded_part = path_fragment_or_descriptor
      
      else
      
        @excluded_part = ::Perspective::Request::Path::PathPart::Fragment.new( path_fragment_or_descriptor )
      
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
