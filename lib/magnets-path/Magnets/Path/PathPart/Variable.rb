
class ::Magnets::Path::PathPart::Variable
	
	include ::Magnets::Path::PathPart
  
	################
	#  initialize  #
	################
	
	def initialize( variable_name_string_or_symbol = nil )
    
    if variable_name_string_or_symbol
		  @variable_name = variable_name_string_or_symbol.to_sym
    end
    
	end
	
	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  @variable_value = request_path.current_part
	  
    request_path.matched_part!
	  
	  return true
	  
  end
  
end
