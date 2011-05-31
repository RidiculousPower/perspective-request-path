
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Rmagnets View Path Multipath Variable  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath::MultipathVariable

	include Rmagnets::ViewPath::PathPart
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )

		matched = false

		@path_variables.each do |this_variable|
			if remaining_request_path_parts.empty?
				matched = false
				break
			else
				matched = true
				path_part = remaining_request_path_parts.shift
				@matched_variables.push( path_part )
				@matched_variable_names[ this_variable ] = path_part
			end
		end

		return matched
		
	end

end
