
class ::Perspective::Request::Path::PathPart::Fragment::MultipathVariableFragment

  include ::Perspective::Request::Path::PathPart::Fragment
  
  ################
	#  initialize  #
	################
	
	def initialize( variable_name_string_or_symbol = nil )
    
    if variable_name_string_or_symbol
		  @variable_name = variable_name_string_or_symbol.to_sym
    end
    
	end
	
end
