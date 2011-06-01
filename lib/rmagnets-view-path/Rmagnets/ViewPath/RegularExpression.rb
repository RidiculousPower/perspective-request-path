
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Rmagnets View Path Regular Expression  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath::RegularExpression < Regexp

	include Rmagnets::ViewPath::PathPart

	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )
		@matched_paths = nil
		if match_data = self.match( remaining_request_path_parts[ 0 ] )
			@matched_paths = [ remaining_request_path_parts.shift ]
		end
		return @matched_paths
	end

end
