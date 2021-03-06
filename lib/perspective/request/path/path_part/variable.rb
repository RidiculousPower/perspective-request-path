# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Variable
	
	include ::Perspective::Request::Path::PathPart
  
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
