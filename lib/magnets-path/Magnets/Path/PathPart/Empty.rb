
class ::Magnets::Path::PathPart::Empty
	
	include ::Magnets::Path::PathPart
	
	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  matched = false
	  
	  if request_path.current_part.nil?
	    
	    matched = true
	    
    end
	  
	  return matched
	  
  end
  
end
