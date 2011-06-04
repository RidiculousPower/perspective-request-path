
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------  Rmagnets View Path Named Optional Part  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart::OptionalPart::Named

	include Rmagnets::ViewPath::PathPart::OptionalPart
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )

		matched_paths = super

		if matched_paths
			@named_optional_parts = fill_named_optional_parts_hash_from_matched_paths( @matched_optional_set, matched_paths.dup )
		else
			@named_optional_parts = nil
		end
		
		return matched_paths

	end
	
	#######################################################
	#  fill_named_optional_parts_hash_from_matched_paths  #
	#######################################################

	def fill_named_optional_parts_hash_from_matched_paths( matched_option_set, matched_paths, named_optional_parts = Hash.new )
		
		matched_option_set.each do |this_name, this_optional_descriptor|
			if this_optional_descriptor.is_a?( Hash )
				nested_named_parts = fill_named_optional_parts_hash_from_matched_paths( this_optional_descriptor, matched_paths )
				named_optional_parts[ this_name ] = nested_named_parts
				named_optional_parts.merge!( nested_named_parts )
			else
				named_optional_parts[ this_name ] = matched_paths.shift
			end
		end
		
		return named_optional_parts
		
	end

	###############################################
	#  match_option_descriptors_for_optional_set  #
	###############################################

	def match_option_descriptors_for_optional_set( optional_set, remaining_descriptor_elements, remaining_request_path_parts )

		matched_paths = Array.new

		optional_set.each do |this_name, this_optional_descriptor|
			
			if this_optional_descriptor.is_a?( Hash )
				nested_matched_paths = nil
				break unless nested_matched_paths = match_option_descriptors_for_optional_set( this_optional_descriptor, remaining_descriptor_elements, remaining_request_path_parts )
				matched_paths.concat( nested_matched_paths )
			else
				break unless this_optional_descriptor.match_request( remaining_descriptor_elements, remaining_request_path_parts )
				matched_paths.concat( this_optional_descriptor.matched_paths )
			end

		end

		matched_paths = nil if matched_paths.empty?
		
		return matched_paths
		
	end

	###########
	#  names  #
	###########

	def names
		return @names ||= Array.new
	end

	##################
	#  current_name  #
	##################

	def current_name
		return @current_name ||= 0
	end
	
	##########################
	#  named_optional_parts  #
	##########################

	def named_optional_parts
		return @named_optional_parts ||= Hash.new
	end
	
end
