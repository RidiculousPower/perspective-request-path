# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Constant

  include ::Perspective::Request::Path::PathPart

  attr_reader :value

	################
	#  initialize  #
	################
	
	def initialize( constant_string )

		@value = constant_string

	end

	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  matched = false

	  if request_path.current_part == @value

	    request_path.matched_part!

  	  matched = true
  	
  	else
  	  
  	  request_path.match_failed!

	  end

	  return matched
	  
  end
  
end
