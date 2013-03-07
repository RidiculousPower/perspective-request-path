# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Exclusion

  include ::Perspective::Request::Path::PathPart

	################
	#  initialize  #
	################
	
	def initialize( path_part_descriptor )

    case path_part_descriptor
    
      when ::Perspective::Request::Path::PathPart
    
        @excluded_part = path_part_descriptor
      
      else
      
        @excluded_part = ::Perspective::Request::Path::PathPart.new( path_part_descriptor )
      
    end
    
	end
	
	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  request_path.begin_optional_match
	  
	  # this needs to be thought out more explicitly
	  # it might even be a bad idea to provide
	  
	  if @excluded_part.match( request_path )
      # if we matched then we failed
	    request_path.failed_match!
	  else
	    request_path.matched_part!
	  end
	  
	  return matched
	  
  end

end
