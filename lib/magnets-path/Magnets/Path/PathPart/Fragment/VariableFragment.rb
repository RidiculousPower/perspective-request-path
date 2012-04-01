
class ::Magnets::Path::PathPart::Fragment::VariableFragment

  include ::Magnets::Path::PathPart::Fragment

	################
	#  initialize  #
	################
	
	def initialize( variable_name_string_or_symbol )

		@variable_name = variable_name_string_or_symbol.to_sym

	end

	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  # variable captures everything so the only way to capture a variable fragment
	  # rather than the whole path part is to look ahead to the next fragment
	  
	  if ! request_path.has_remaining_fragment?

      request_path.matched_fragment!( request_path.current_fragment.length )
	  
	  elsif matched_fragment = request_path.match_fragment_by_look_ahead

      request_path.matched_fragment!( matched_fragment.length )
    
    end
    
	  return true
	  
  end

end
