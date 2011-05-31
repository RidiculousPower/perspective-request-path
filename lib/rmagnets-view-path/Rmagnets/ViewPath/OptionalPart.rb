
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Rmagnets View Path Optional Part  -------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath::OptionalPart

	include Rmagnets::ViewPath::PathPart

	################
	#  initialize  #
	################

	def initialize( *optional_path_parts )
		
		@optional_sets = optional_path_parts.nested_permutations
				
	end

	###################
	#  match_request  #
	###################

	# optional parts are sets that are all-or-nothing
	# nesting optional parts allows exceptions to this principle
	# matching optional sets happens in reverse, attempting to match all optional parts first
	# [ optional_path_part1_1, optional_path_part1_2, [ optional_path_part2_4 ], optional_path_part1_3 ]
	def match_request( remaining_descriptor_elements, remaining_request_path_parts )

		matched_paths        = nil
		@matched_optional_set = nil
		
		# count number of non-optional descriptors remaining
		number_of_non_optional_descriptors_remaining	=	remaining_descriptor_elements.select do |element|
			! element.is_a?( Rmagnets::ViewPath::OptionalPart )
		end.count
		
		# for each set of possible optional parts:
		@optional_sets.each do |this_optional_set|

			# make sure we have enough path parts to accomodate the set
			# and make sure we have enough path parts to accomodate remaining descriptors if this set matches
			next unless path_accomodates_optional_set( number_of_non_optional_descriptors_remaining, remaining_request_path_parts, this_optional_set )
			
			# * we look ahead the # of possible optional parts and attempt to match n + 1 until the end
			next unless match_remaining_descriptors_for_optional_set( this_optional_set, remaining_descriptor_elements.dup, remaining_request_path_parts )
			
			# * if it matches (including no further descriptor/path parts), attempt to match each option descriptor in this set
			if matched_paths = match_option_descriptors_for_optional_set( this_optional_set, remaining_descriptor_elements.dup, remaining_request_path_parts )
				@matched_optional_set = this_optional_set
				break
			end
			
		end
		
		if matched_paths
			@matched_paths = matched_paths
		end
		
		return matched_paths
		
	end
	
	##############################################
	#  path_parts_remaining_after_optional_set  #
	##############################################

	def path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts )
		return remaining_request_path_parts.slice( optional_set.count, remaining_request_path_parts.count )
	end
	
	##################################################
	#  match_remaining_descriptors_for_optional_set  #
	##################################################

	def match_remaining_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts )

		matched_paths = Array.new

		remaining_path_parts = path_parts_remaining_after_optional_set( optional_set, remaining_request_path_parts )

		unless remaining_path_parts.nil?

			until remaining_descriptor_elements.empty?

				# if we run out of path and still have descriptors we don't match
				break if remaining_path_parts.empty?

				this_remaining_descriptor = remaining_descriptor_elements.shift

				# if one of our descriptors returns failure for matching, this set does not match - go to the next set
				break unless this_remaining_descriptor.match_request( remaining_descriptor_elements, remaining_path_parts )

				matched_paths.concat( this_remaining_descriptor.matched_paths )
				
			end

		end

		matched_paths = nil if matched_paths.empty?

		return matched_paths
		
	end

	###############################################
	#  match_option_descriptors_for_optional_set  #
	###############################################

	def match_option_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts )

		matched_paths = Array.new

		optional_set.each do |this_optional_descriptor|
			# if one of our optional descriptors fails, we do not match this optional set
			break unless this_optional_descriptor.match_request( remaining_descriptor_elements, remaining_request_path_parts )
			matched_paths.concat( this_optional_descriptor.matched_paths )
		end
		
		matched_paths = nil if matched_paths.empty?

		return matched_paths
		
	end

	#########################################################
	#  number_of_additional_path_parts_if_this_set_matches  #
	#########################################################
	
	def number_of_additional_path_parts_if_this_set_matches( remaining_request_path_parts, optional_set )
		return remaining_request_path_parts.count - optional_set.count
	end

	###################################
	#  path_accomodates_optional_set  #
	###################################

	def path_accomodates_optional_set( number_of_non_optional_descriptors_remaining, remaining_request_path_parts, optional_set )
		
		path_accomodates_set = false
		
		if remaining_request_path_parts.count >= optional_set.count	and
			 number_of_additional_path_parts_if_this_set_matches( remaining_request_path_parts, optional_set ) >= number_of_non_optional_descriptors_remaining
			
			path_accomodates_set = true
			
		end
		
		return path_accomodates_set
		
	end
	
end
