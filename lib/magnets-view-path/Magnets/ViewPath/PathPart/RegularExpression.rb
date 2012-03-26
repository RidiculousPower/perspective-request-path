
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Rmagnets View Path Regular Expression  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart::RegularExpression

	include ::Rmagnets::ViewPath::PathPart

	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )
		
		@matched_paths = nil
		
		if match_data = self.match( remaining_request_path_parts[ 0 ] )  and
		   match_data[ 0 ] == remaining_request_path_parts[ 0 ]
			
			@matched_paths = [ remaining_request_path_parts.shift ]
		
		end
		
		return @matched_paths
	
	end

end
