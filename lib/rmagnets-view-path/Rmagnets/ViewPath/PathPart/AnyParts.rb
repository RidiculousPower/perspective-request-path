
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rmagnets View Path Any Parts  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart::AnyParts

	include Rmagnets::ViewPath::PathPart
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )
		return @matched_paths = remaining_request_path_parts
	end
	
end
