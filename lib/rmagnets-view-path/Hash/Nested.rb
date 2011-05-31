
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------------  Nested Hash  -----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Hash::Nested < Hash

	###########
	#  count  #
	###########

	def count
		nested_members_count = 0
		each do |this_name, this_descriptor_or_nested_set| 
			nested_members_count += ( this_descriptor_or_nested_set.is_a?( Hash ) ? this_descriptor_or_nested_set.count : 1 )
		end
		return nested_members_count
	end

end

