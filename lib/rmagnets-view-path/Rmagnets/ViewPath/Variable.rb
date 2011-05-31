
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rmagnets View Path Variable  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath::Variable
	
	include Rmagnets::ViewPath::PathPart

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
		return @matched_paths = [ remaining_request_path_parts.shift ] if remaining_request_path_parts[ 0 ]
	end
	
end
