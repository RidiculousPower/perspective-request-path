
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------------  Hash  -----------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Hash

	#########################
	#  nested_permutations  #
	#########################

	def nested_permutations

		@existing_sets = Array::Nested.new( [ Hash::Nested.new ] )

		self.each do |this_name, this_descriptor_or_nested_set|

			# nested routes get applied to all possible routes before them _and_ keep the existing routes
			if this_descriptor_or_nested_set.is_a?( Hash )

				# get nested sets
				nested_sets = this_descriptor_or_nested_set.nested_permutations

				# for each existing set create a second set that includes each of nested_sets
				additional_sets = Array.new
				@existing_sets.each do |existing_set|
					nested_sets.each do |nested_set|
						full_set_for_this_nested_set_option = existing_set.dup
						full_set_for_this_nested_set_option[ this_name ] = nested_set
						additional_sets.push( full_set_for_this_nested_set_option )
					end
				end

				@existing_sets += additional_sets

			else
				
				# constant get concatenated to all possible before them
				# any additional constants always get appended to existing ordered sets
				# :optional1, [ :optional2 ], :optional3
				# 1 and 3 should always be together, whether or not 2 is present

				@existing_sets.each do |existing_set|
					existing_set[ this_name ] = this_descriptor_or_nested_set
				end
				
			end
			
			
		end

		return @existing_sets.sort_by { |existing_set| existing_set.count }.reverse

	end
	
end
