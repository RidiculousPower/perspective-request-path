
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rmagnets View Path Any Parts  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart::AnyParts

	include ::Rmagnets::ViewPath::PathPart
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )

		@matched_paths = [ ]
		@matched_paths.concat( remaining_request_path_parts )
		remaining_request_path_parts.shift until remaining_request_path_parts.empty?
		@matched_paths.push( '/' ) if @matched_paths.empty?

		return @matched_paths

	end
	
end
