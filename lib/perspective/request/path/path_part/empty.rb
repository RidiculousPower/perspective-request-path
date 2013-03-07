# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Empty
	
	include ::Perspective::Request::Path::PathPart
	
	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  matched = false
	  
	  if request_path.current_part.nil?
	    
	    matched = true
	  
	  else
	    
	    request_path.match_failed!
      
    end
	  
	  return matched
	  
  end
  
end
