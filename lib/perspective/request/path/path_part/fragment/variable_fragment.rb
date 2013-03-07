# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Fragment::VariableFragment

  include ::Perspective::Request::Path::PathPart::Fragment

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
	  
	  # variable captures everything so the only way to capture a variable fragment
	  # rather than the whole path part is to look ahead to the next fragment
	  if ! request_path.has_remaining_fragment?( 1 )

      request_path.matched_fragment!( request_path.current_fragment.length )
	  
	  elsif matched_fragment_index = request_path.look_ahead_fragment_match
      
      request_path.matched_fragment!( matched_fragment_index )
    
    end
    
	  return true
	  
  end

end
