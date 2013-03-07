# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment

  include ::Perspective::Request::Path::PathPart::Fragment
  
	################
	#  initialize  #
	################
	
	def initialize( constant_string )
    
		@constant_value = constant_string
    
	end

	###########
	#  match  #
	###########
	
	def match( request_path )

	  matched = false

	  if request_path.matched_fragment( self )
	    
	    matched = true
	    
	  elsif request_path.current_fragment.start_with?( @constant_value )

	    request_path.matched_fragment!( @constant_value.length )

  	  matched = true

	  end

	  return matched
	  
  end
  
  ######################
	#  look_ahead_match  #
	######################
	
  def look_ahead_match( request_path )
    
    index = nil
	  
	  if index = request_path.current_fragment.index( @constant_value )

	    request_path.matched_look_ahead_fragment!( index, @constant_value.length )

	  end

	  return index, @constant_value.length
    
  end
  
end
