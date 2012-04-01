
class ::Magnets::Path::PathPart::Exclusion

  include ::Magnets::Path::PathPart

	################
	#  initialize  #
	################
	
	def initialize( path_part_descriptor )

    case path_part_descriptor
    
      when ::Magnets::Path::PathPart
    
        @excluded_part = path_part_descriptor
      
      else
      
        @excluded_part = ::Magnets::Path::PathPart.new( path_part_descriptor )
      
    end
    
	end
	
	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  return ! @excluded_part.match( request_path )
	  
  end

end
