
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------  Rmagnets View Path Named Optional Part  ---------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::PathPart::OptionalPart::Named

	include ::Rmagnets::ViewPath::PathPart::OptionalPart
	
	###################
	#  match_request  #
	###################

	def match_request( remaining_descriptor_elements, remaining_request_path_parts )

		matched_paths = super

		if matched_paths
			@named_optional_parts = named_optional_parts_from_matched_paths( @matched_optional_set, 
			                                                                 matched_paths.dup )
		else
			@named_optional_parts = nil
		end
		
		return matched_paths

	end
	
	#############################################
	#  named_optional_parts_from_matched_paths  #
	#############################################

	def named_optional_parts_from_matched_paths( matched_option_set, 
	                                                  matched_paths, 
	                                                  named_optional_parts = { } )
		
		matched_option_set.each do |this_name, this_optional_descriptor|
			if this_optional_descriptor.is_a?( Hash )
				nested_named_parts = named_optional_parts_from_matched_paths( this_optional_descriptor, 
				                                                              matched_paths )
				named_optional_parts[ this_name ] = nested_named_parts
				named_optional_parts.merge!( nested_named_parts )
			else
				named_optional_parts[ this_name ] = matched_paths.shift
			end
		end
		
		return named_optional_parts
		
	end

	########################
	#  match_optional_set  #
	########################

	def match_optional_set( optional_set, 
	                        remaining_descriptor_elements, 
	                        remaining_request_path_parts )

		matched_paths = nil

		optional_set.each do |this_name, this_optional_descriptor|
			
			if this_optional_descriptor.is_a?( Hash )
				
				break unless nested_matched_paths = match_optional_set( this_optional_descriptor, 
				                                                        remaining_descriptor_elements, 
				                                                        remaining_request_path_parts )
				
				matched_paths ||= [ ]

				matched_paths.concat( nested_matched_paths )

			else

			  break unless this_optional_descriptor.match_request( remaining_descriptor_elements, 
			                                                       remaining_request_path_parts )

				matched_paths ||= [ ]

				matched_paths.concat( this_optional_descriptor.matched_paths )

			end

		end
		
		return matched_paths
		
	end

	###########
	#  names  #
	###########

	def names
		return @names ||= [ ]
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
		return @named_optional_parts ||= { }
	end
	
end
