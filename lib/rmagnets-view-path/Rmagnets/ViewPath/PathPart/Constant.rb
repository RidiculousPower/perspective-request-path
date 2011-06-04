
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rmagnets View Path Constant  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart::Constant

	include Rmagnets::ViewPath::PathPart
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )
		return @matched_paths = [ remaining_request_path_parts.shift ] if ( remaining_request_path_parts[ 0 ] ) == self
	end
	
end