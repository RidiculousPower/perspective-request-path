
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rmagnets View Path  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath

	#############################
  #  path_fragments_for_path  #
  #############################
  
	def path_fragments_for_path( request_path )
		
		# we modify a split array of parts rather than the path string
		remaining_request_path_parts = request_path.split( '/' )
		# if the path string starts with '/' the first item on the array will be ''
		remaining_request_path_parts.shift if request_path[ 0 ] == '/'
		
		return remaining_request_path_parts
		
	end

	############################
  #  regularized_path_parts  #
  ############################

	def regularized_path_parts( path_parts )
		
		regularized_path_parts = Array.new
		
		path_parts.each do |this_part|

			if	this_part.is_a?( Symbol )

				regularized_path_parts.push( Rmagnets::ViewPath::PathPart::Variable.new( this_part ) )

			# * regexp for individual or multiple parts
			elsif	this_part.is_a?( Regexp )

				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::RegularExpression ) )
						
			# * arrays denote optional portions ( [ :optional_var, :optional_var, [ :optional_var ], :optional_var ] )
			elsif this_part.is_a?( Array )

				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::OptionalPart ) )

			# * hashes denote named optional portions ( { :optional_name => :optional_var, :optional_name => 'part' } )
			elsif this_part.is_a?( Hash )

				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::OptionalPart::Named ) )

			# * individual and multiple path fragment ( some/path/to/somewhere )
			else
				
				regularized_path_parts.concat( parse_path_fragment( this_part ) )
				
			end

		end
		
		return regularized_path_parts
		
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
			elsif variable_path_fragment?( this_part )

				variable_name = this_part.slice( 1, this_part.length - 1 )
				regularized_path_parts.push( Rmagnets::ViewPath::PathPart::Variable.new( variable_name ) )

			elsif regexp_path_fragment?( this_part )

				regexp = this_part.slice( 1, this_part.length - 1 )
				regularized_path_parts.push( Regexp.new( regexp ).extend( Rmagnets::ViewPath::PathPart::RegularExpression ) )

			elsif anypath_path_fragment?( this_part )

				# two possibilities:
				# * pathpart*
				# * pathpart/* => *
				
				anypath_parts = this_part.split( '*' )
				
				unless anypath_parts.empty?
					regularized_path_parts.push( anypath_parts[ 0 ].extend( Rmagnets::ViewPath::PathPart::Constant ) )
				end

				regularized_path_parts.push( '*'.extend( Rmagnets::ViewPath::PathPart::AnyParts ) )

			# * individual path fragment ( path )
			else

				# string
				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::Constant ) )

			end

		end

		return regularized_path_parts
		
	end

  #############################
  #  variable_path_fragment?  #
  #############################

	def variable_path_fragment?( path_fragment )
		return path_fragment[ 0 ] == VariableDelimiter && path_fragment[ path_fragment.length - 1 ] == VariableDelimiter
	end

  ###########################
  #  regexp_path_fragment?  #
  ###########################

	def regexp_path_fragment?( path_fragment )
		return path_fragment[ 0 ] == RegexpDelimiter && path_fragment[ path_fragment.length - 1 ] == RegexpDelimiter
	end

  ############################
  #  anypath_path_fragment?  #
  ############################

	def anypath_path_fragment?( path_fragment )
		return path_fragment[ path_fragment.length - 1 ] == AnyPathDelimiter
	end
	
end
