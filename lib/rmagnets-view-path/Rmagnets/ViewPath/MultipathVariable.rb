
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Rmagnets View Path Multipath Variable  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath::MultipathVariable

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

		matched_paths = nil

		# we need to know which next part should match
		# if we have a constant we know
		# if we have the end we know

		# look until we have a constant or the end
		# if we have a constant, check if it matches; if it does, match till the end of the set of descriptors
		# if we are at the end (whether before or after a constant), we need to interpret the set of descriptors between self and end or first constant
		# this can consist in: optional parts, named optional parts, regexp, multipath regexp

		# if we have optional or named optional parts we don't know
		# if we have a regexp or multipath regexp we don't know

		# we need to find the next determinate part
		
		# look until constant or end
		# check next descriptor
		# if at end and descriptor, fail
		# if at end and no descriptor, success
		# now we need to check the rest of the descriptors
		# variables we count backward from the next constant, optional/named optional, or end
		
		# if we have optional or named optional part, ask it to check the remainder
		
		
		return matched_paths
		
	end

end
