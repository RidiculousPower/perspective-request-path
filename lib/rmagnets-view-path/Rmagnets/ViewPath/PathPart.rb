
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------  Rmagnets View Path Path Part  -------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart

	#######################
	#  matched_variables  #
	#######################

	def matched_variables
		return @matched_variables ||= Array.new
	end

	###################
	#  matched_paths  #
	###################

	def matched_paths
		return @matched_paths ||= Array.new
	end
	
end
