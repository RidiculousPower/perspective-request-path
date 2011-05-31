
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rmagnets View Path  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath

	#########################
  #  path_parts_for_path  #
  #########################
  
	def path_parts_for_path( request_path )
		
		# we modify a split array of parts rather than the path string
		remaining_request_path_parts = request_path.split( '/' )
		# if the path string starts with '/' the first item on the array will be ''
		remaining_request_path_parts.shift if request_path[ 0 ] == '/'
		
		return remaining_request_path_parts
		
	end

  #########################
  #  sub_route_for_route  #
  #########################

	def sub_route_for_route( route_base, active_route )
		return route.slice( route_base.length, route.length )
	end

  #########################
  #  parse_path_fragment  #
  #########################

	def parse_path_fragment( path_fragment )
		
		regularized_path_parts = Array.new
		
		path_fragment.split( '/' ).each do |this_part|

			# if we have "" (which happens when '/' is at either end)
			if this_part.empty?

				next

			# * variable individual path fragment embedded in path fragment, individual or multiple ( '%individual_variable_fragment%' )
			elsif parse_variable_path_fragment( this_part )

				variable_name = this_part.slice( 1, this_part.length - 1 )
				regularized_path_parts.push( variable_name.to_sym )

			# * variable multiple path fragment embedded in path fragment ( '@multiple_variable_fragment@' )
			elsif parse_multiple_variable_path_fragment( this_part )

				variable_name = this_part.slice( 1, this_part.length - 1 )
				regularized_path_parts.push( Rmagnets::ViewPath::MultipathVariable.new( variable_name ) )

			# * individual path fragment ( path )
			else

				# string
				regularized_path_parts.push( Rmagnets::ViewPath::Constant.new( this_part ) )

			end

		end
		
		return regularized_path_parts
		
	end

  ##################################
  #  parse_variable_path_fragment  #
  ##################################

	def parse_variable_path_fragment( path_fragment )
		return path_fragment[ 0 ] == VariableDelimiter && path_fragment[ path_fragment.length ] == VariableDelimiter
	end

  ###########################################
  #  parse_multiple_variable_path_fragment  #
  ###########################################

	def parse_multiple_variable_path_fragment( path_fragment )
		return path_fragment[ 0 ] == MultipathVariableDelimiter && path_fragment[ path_fragment.length ] == MultipathVariableDelimiter
	end
	
end
