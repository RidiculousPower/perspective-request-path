
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------------  Array  -----------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::ViewPath::Array

	#########################
	#  nested_permutations  #
	#########################

	def nested_permutations

		@existing_sets = Array::Nested.new( [ [] ] )

		self.each do |this_constant_or_nested_set|

			# nested routes get applied to all possible routes before them _and_ keep the existing routes
			if this_constant_or_nested_set.is_a?( Array )
				
				# get nested sets
				nested_sets = this_constant_or_nested_set.nested_permutations

				# for each existing set create a second set that includes each of nested_sets
				additional_sets = [ ]
				@existing_sets.each_with_index do |existing_set, index|
					nested_sets.each do |nested_set|
						additional_sets.push( existing_set + nested_set )
					end
				end

				@existing_sets += additional_sets

			# constant routes get concatenated to all possible routes before them
			else

				# any additional constants always get appended to existing ordered sets
				# :optional1, [ :optional2 ], :optional3
				# 1 and 3 should always be together, whether or not 2 is present
				@existing_sets.each_with_index do |this_ordered_set, index|
					@existing_sets[ index ] << this_constant_or_nested_set
				end

			end
			
		end
		
		return @existing_sets.sort_by { |member| member.count }.reverse

	end
		
end


