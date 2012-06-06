
class ::Magnets::Path::PathPart::Multiple::MultipathVariable

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
	  
	  matched = false
	  
	  @descriptors.each do |this_descriptor|
	    
	    case this_descriptor
        when ::Magnets::Path::String::MultiPathWildcardDelimiter
      end
	    
    end
    
	  
	  if request_path.current_part == @constant_value

	    request_path.matched_part!

  	  matched = true

	  end
	  
	  return matched
	  
  end
  

	###################
	#  match_request  #
	###################

	def match_request( request_path )
	  
	  request_path.match_until_next_part_matches_or_fail!

	end

end
