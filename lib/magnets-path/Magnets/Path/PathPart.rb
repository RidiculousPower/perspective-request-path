
module ::Magnets::Path::PathPart

	PathDelimiter = '/'

	# Path strings with %name% are converted to ::Magnets::Path::PathPart::Variable or
	# ::Magnets::Path::PathPart::Fragment::VariableFragment
	#
	VariableDelimiter = '%'
	
	# Path strings with #regexp# are converted to ::Magnets::Path::PathPart::Regexp or
	# ::Magnets::Path::PathPart::Fragment::RegexpFragment
	#
	RegexpDelimiter = '#'

	# Path strings with !descriptor! are converted to ::Magnets::Path::PathPart::Exclusion or
	# ::Magnets::Path::PathPart::Fragment::ExclusionFragment
	#
	ExclusionDelimiter = '!'

	# Path strings with |descriptor| are converted to ::Magnets::Path::PathPart::Optional or
	# ::Magnets::Path::PathPart::Fragment::OptionalFragment
	#
	OptionalDelimiter = '|'
	
	# If an OptionalDelimiter is followed by an OptionalNameDelimiter before the second paired
	# OptionalDelimiter, the first value between is treated as a named option, while the second
	# value between is treated as the option value.
	# 
	OptionalNameDelimiter = ':'
	
	# Path strings including * match wildcard portions are converted to 
	# ::Magnets::Path::PathPart::Variable or ::Magnets::Path::PathPart::Fragment::VariableFragment
	#
	WildcardDelimiter = '*'

	# Path strings including ** match wildcard portions for multiple paths are converted to 
	# ::Magnets::Path::PathPart::MultipathVariable or 
	# ::Magnets::Path::PathPart::Fragment::MultipathVariableFragment
	#
	MultiPathWildcardDelimiter = '**'
  
  ##############
  #  self.new  #
  ##############
  
  # expects single path part (no path delimiter)
  def self.new( path_descriptor )
    
    case path_descriptor
		  
			when ::String
			  
		    path_descriptor = ::Magnets::Path::
		                        PathPart.parse_path_part_string_for_descriptors( path_descriptor )
			  
		  when ::Symbol

        path_descriptor = ::Magnets::Path::PathPart::Variable.new( path_descriptor )

			# * regexp for individual or multiple parts
		  when ::Regexp

        path_descriptor = ::Magnets::Path::PathPart::Regexp.new( path_descriptor )
				
			# * arrays denote optional portions 
			#   ( [ :optional_var, :optional_var, [ :optional_var ], :optional_var ] )
	    when ::Array

        path_descriptor = ::Magnets::Path::PathPart::Optional.new( *path_descriptor )

			# * hashes denote named optional portions 
			#   ( { :optional_name => :optional_var, :optional_name => 'part' } )
  		when ::Hash

        path_descriptor = ::Magnets::Path::PathPart::Optional::NamedOptional.new( path_descriptor )

		end
    
    return path_descriptor
    
  end

  #######################################
  #  self.parse_string_for_descriptors  #
  #######################################
  
  def self.parse_string_for_descriptors( descriptor_string )
  
    descriptors = [ ]
  
    path_parts = descriptor_string.split( ::Magnets::Path::PathPart::PathDelimiter )
    
    if path_parts.count > 1
      path_parts.each do |this_path_part_string|
        descriptors.push( parse_path_part_string_for_descriptors( this_path_part_string ) )
      end
    else
      descriptors.push( parse_path_part_string_for_descriptors( descriptor_string ) )
    end
    
    return descriptors
    
  end

  #################################################
  #  self.parse_path_part_string_for_descriptors  #
  #################################################
  
  def self.parse_path_part_string_for_descriptors( descriptor_string, fragment_for_multiple = nil )
    
    # we already split on '/' and '**' and '*'
    
    descriptor = nil
    
    case descriptor_string[ 0 ]

      when ::Magnets::Path::PathPart::WildcardDelimiter
        
        # multiple path-part wildcard
        if descriptor_string[ 0..1 ] == ::Magnets::Path::PathPart::MultiPathWildcardDelimiter

          descriptor = parse_path_part_for_fragment( descriptor_string,
                                                     0..1,
                                                     ::Magnets::Path::PathPart::Fragment::
                                                       MultipathWildcardFragment,
                                                     2,
                                                     fragment_for_multiple )

        # single path-part wildcard
        else

          descriptor = parse_path_part_for_fragment( descriptor_string,
                                                     0...1,
                                                     ::Magnets::Path::PathPart::Fragment::
                                                       WildcardFragment,
                                                     1,
                                                     fragment_for_multiple )
          
        end

      # regexp
      when ::Magnets::Path::PathPart::RegexpDelimiter
      
        descriptor = parse_descriptor_for_part_or_fragment( descriptor_string, 
                                                            ::Magnets::Path::PathPart::
                                                              RegexpDelimiter,
                                                            ::Magnets::Path::PathPart::Regexp,
                                                            ::Magnets::Path::PathPart::Fragment::
                                                              RegexpFragment,
                                                            fragment_for_multiple )
        
      # variable name
      when ::Magnets::Path::PathPart::VariableDelimiter
      
        descriptor = parse_descriptor_for_part_or_fragment( descriptor_string, 
                                                            ::Magnets::Path::PathPart::
                                                              VariableDelimiter,
                                                            ::Magnets::Path::PathPart::Variable,
                                                            ::Magnets::Path::PathPart::Fragment::
                                                              VariableFragment,
                                                            fragment_for_multiple )
    
      # constant
      else

        # look for '#'
        if regexp_fragment_index = descriptor_string.index( ::Magnets::Path::PathPart::
                                                              RegexpDelimiter )

          descriptor = parse_path_part_for_fragment( descriptor_string,
                                                     0...regexp_fragment_index,
                                                     ::Magnets::Path::PathPart::Fragment::
                                                       ConstantFragment,
                                                     regexp_fragment_index,
                                                     fragment_for_multiple )
          
        # or '%'
        elsif variable_fragment_index = descriptor_string.index( ::Magnets::Path::PathPart::
                                                                   VariableDelimiter )
          
          descriptor = parse_path_part_for_fragment( descriptor_string,
                                                     0...variable_fragment_index,
                                                     ::Magnets::Path::PathPart::Fragment::
                                                       ConstantFragment,
                                                     variable_fragment_index,
                                                     fragment_for_multiple )

        else
          
          if fragment_for_multiple
            descriptor = fragment_for_multiple
            constant_fragment = ::Magnets::Path::PathPart::Fragment::
                                  ConstantFragment.new( descriptor_string )
            descriptor.add_fragment( constant_fragment )
          else
            descriptor = ::Magnets::Path::PathPart::Constant.new( descriptor_string )
          end
          
        end
        # * if so, we have a constant path part
        # * if not, we have a constant path part fragment
      
    end
    
    return descriptor
    
  end
  
  ################################################
  #  self.parse_descriptor_for_part_or_fragment  #
  ################################################
  
  def self.parse_descriptor_for_part_or_fragment( descriptor_string, 
                                                  delimiter,
                                                  part_class,
                                                  fragment_class,
                                                  fragment_for_multiple = nil )
    
    # look for index of next '#'
    unless fragment_end_index = descriptor_string[ 1..-1 ].index( delimiter )
      raise ::ArgumentError, 'Expected matching ' + delimiter + ' in "' + descriptor_string + '".'
    end
    
    # check if index is the end of the descriptor string
    if fragment_for_multiple or 
       fragment_end_index < descriptor_string.length - 2
      
      # * if not, we have a regexp path part fragment
      descriptor = parse_path_part_for_fragment( descriptor_string,
                                                 1...fragment_end_index,
                                                 fragment_class,
                                                 fragment_end_index + ( delimiter ? 2 : 1 ),
                                                 fragment_for_multiple )

    else

      # * if so, we have a regexp path part
      descriptor = part_class.new( descriptor_string[ 1..-2 ] )

    end
    
    return descriptor
    
  end
  
  #######################################
  #  self.parse_path_part_for_fragment  #
  #######################################
  
  def self.parse_path_part_for_fragment( descriptor_string,
                                         starting_fragment_range,
                                         starting_fragment_class,
                                         next_fragment_start_index,
                                         fragment_for_multiple = nil )
    
    fragment_descriptor = nil
    
    if fragment_for_multiple
      fragment_descriptor = fragment_for_multiple
    else
      fragment_descriptor = ::Magnets::Path::PathPart::Multiple.new
    end

    new_fragment = starting_fragment_class.new( descriptor_string[ starting_fragment_range ] )
    
    fragment_descriptor.add_fragment( new_fragment )
    
    next_string_descriptor_range = next_fragment_start_index..-1
    parse_path_part_string_for_descriptors( descriptor_string[ next_string_descriptor_range ],
                                            fragment_descriptor )

    return fragment_descriptor
    
  end

  #################################
  #  self.regularize_descriptors  #
  #################################
  
  def self.regularize_descriptors( *descriptors )

    regularized_descriptors = [ ]
    
    descriptors.each do |this_path_descriptor|

      case this_path_descriptor

        when ::Magnets::Path::PathPart
          
          regularized_descriptors.push( this_path_descriptor )
        
        when ::String
          
          regularized_descriptors.concat( parse_string_for_descriptors( this_path_descriptor ) )
        
        else
          
          regularized_descriptors.push( new( this_path_descriptor ) )

      end
            
    end
    
    return regularized_descriptors

  end
  
end
