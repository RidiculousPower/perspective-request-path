
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rmagnets View Path Variable  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class ::Rmagnets::ViewPath::PathPart::Variable

	# this is the only Rmagnets::ViewPath::PathPart that is a class rather than a module
	# this is because instances of Symbol cannot be extended
	
	include ::Rmagnets::ViewPath::PathPart

	################
	#  initialize  #
	################
	
	def initialize( variable_name )

		@variable_name = variable_name.to_sym

	end
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )

    if remaining_request_path_parts[ 0 ]
		  return @matched_paths = [ remaining_request_path_parts.shift ]
	  end

	end
	
end
