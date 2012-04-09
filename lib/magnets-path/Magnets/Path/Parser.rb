
module ::Magnets::Path::Parser

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
	OptionalPartDelimiter = ','
	
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
  
  # Descriptors to match for fragments
  Delimiters = [ VariableDelimiter,
                 RegexpDelimiter,
                 ExclusionDelimiter,
                 OptionalDelimiter,
                 WildcardDelimiter,
                 MultiPathWildcardDelimiter ]

  #######################################
  #  self.parse_string_for_descriptors  #
  #######################################
  
  def self.parse_string_for_descriptors( descriptor_string )
  
    descriptors = [ ]
    
    # get rid of leading /
    if descriptor_string[ 0 ] == ::Magnets::Path::Parser::PathDelimiter
      descriptor_string.slice!( 1..-1 )
    end

    # and trailing /
    if descriptor_string[ -1 ] == ::Magnets::Path::Parser::PathDelimiter
      descriptor_string.slice!( -1..-1 )
    end
    
    # and loop, breaking on /
    until descriptor_string.empty?

      path_part = nil

      if index = descriptor_string.index( ::Magnets::Path::Parser::PathDelimiter )
        path_part = descriptor_string.slice!( 0..index )[ 0..-2 ]
      else
        path_part = descriptor_string
      end
    
      this_descriptor = parse_path_part_string( path_part )
      
      descriptors.push( this_descriptor )
      
    end
    
    return descriptors
    
  end
  
  #################################
  #  self.parse_path_part_string  #
  #################################
  
  def self.parse_path_part_string( descriptor_string, multiple_capturing_fragments = nil )
    
    descriptor = nil
    
    case descriptor_string[ 0 ]
      
      when ::Magnets::Path::Parser::RegexpDelimiter
        
        descriptor = parse_path_part_for_regexp( descriptor_string, 
                                                 multiple_capturing_fragments )
        
      when ::Magnets::Path::Parser::VariableDelimiter

        descriptor = parse_path_part_for_variable( descriptor_string, 
                                                   multiple_capturing_fragments )

      when ::Magnets::Path::Parser::OptionalDelimiter

        descriptor = parse_path_part_for_optional( descriptor_string, 
                                                   multiple_capturing_fragments )

      when ::Magnets::Path::Parser::ExclusionDelimiter

        descriptor = parse_path_part_for_exclusion( descriptor_string, 
                                                    multiple_capturing_fragments )
    
      when ::Magnets::Path::Parser::WildcardDelimiter

        if descriptor_string[ 0...2 ] == ::Magnets::Path::Parser::MultiPathWildcardDelimiter

          descriptor = parse_path_part_for_multipath_wildcard( descriptor_string, 
                                                               multiple_capturing_fragments )
          
        else
        
          descriptor = parse_path_part_for_wildcard( descriptor_string, 
                                                     multiple_capturing_fragments )
        
        end
        
      # constant
      else

        descriptor = parse_path_part_for_constant( descriptor_string, 
                                                   multiple_capturing_fragments )
    
    end
    
    return descriptor
    
  end

  #################################################
  #  self.parse_path_part_for_multipath_wildcard  #
  #################################################
  
  def self.parse_path_part_for_multipath_wildcard( descriptor_string, 
                                                   multiple_capturing_fragments = nil )
    
    descriptor_string.slice!( 0...2 )
    
    descriptor = ::Magnets::Path::
                   PathPart.create_part_or_fragment( descriptor_string, 
                                                     ::Magnets::Path::
                                                       PathPart::Multiple::MultipathVariable, 
                                                     ::Magnets::Path::
                                                       PathPart::Fragment::MultipathVariableFragment, 
                                                     multiple_capturing_fragments )  
    
    return descriptor
    
  end

  #######################################
  #  self.parse_path_part_for_wildcard  #
  #######################################
  
  def self.parse_path_part_for_wildcard( descriptor_string, multiple_capturing_fragments = nil )
    
    # we were passed * - the rest (if there is any) is a fragment
    descriptor_string.slice!( 0...1 )
    
    descriptor = ::Magnets::Path::
                   PathPart.create_part_or_fragment( descriptor_string, 
                                                     ::Magnets::Path::PathPart::Variable, 
                                                     ::Magnets::Path::
                                                       PathPart::Fragment::VariableFragment, 
                                                     multiple_capturing_fragments )  
    
    return descriptor
    
  end
  
  #######################################
  #  self.parse_path_part_for_constant  #
  #######################################
  
  def self.parse_path_part_for_constant( descriptor_string, multiple_capturing_fragments = nil )
  	
  	descriptor = nil
  	
  	slice_index = nil
  	
  	should_break = false
  	
  	descriptor_string.chars.each_with_index do |this_char, index|

    	Delimiters.each do |this_delimiter|

    	  if this_char == this_delimiter
    	    slice_index = index
    	    should_break = true
  	      break
  	    end
  	  
  	  end
  	  
  	  break if should_break

    end
    
    part_creation_parameter = nil

    if slice_index
  	  part_creation_parameter = descriptor_string.slice!( 0...slice_index )      
    else
      # we want to leave descriptor_string empty so we stop parsing
  	  part_creation_parameter = descriptor_string.slice!( 0..-1 )
    end

    descriptor = ::Magnets::Path::
                   PathPart.create_part_or_fragment( descriptor_string, 
                                                     ::Magnets::Path::PathPart::Constant, 
                                                     ::Magnets::Path::
                                                       PathPart::Fragment::ConstantFragment, 
                                                     multiple_capturing_fragments,
                                                     part_creation_parameter )  
  	    
    return descriptor
    
  end
  
  #######################################
  #  self.parse_path_part_for_variable  #
  #######################################
  
  def self.parse_path_part_for_variable( descriptor_string, multiple_capturing_fragments = nil )

    # we were passed %... - we need to look for %

    index = descriptor_string[ 1..-1 ].index( ::Magnets::Path::Parser::VariableDelimiter ) + 1

    unless index
      raise ::ArgumentError, 'Expected matching ' + ::Magnets::Path::Parser::VariableDelimiter + 
                             ' in "' + descriptor_string + '".'
    end

    variable_name = descriptor_string.slice!( 0..index )[ 1..-2 ]
        
    return ::Magnets::Path::
             PathPart.create_part_or_fragment( descriptor_string, 
                                               ::Magnets::Path::PathPart::Variable, 
                                               ::Magnets::Path::
                                                 PathPart::Fragment::VariableFragment, 
                                               multiple_capturing_fragments,
                                               variable_name )
    
  end
  
  #####################################
  #  self.parse_path_part_for_regexp  #
  #####################################

  def self.parse_path_part_for_regexp( descriptor_string, multiple_capturing_fragments = nil )

    # we were passed #... - we need to look for #
    index = descriptor_string[ 1..-1 ].index( ::Magnets::Path::Parser::RegexpDelimiter ) + 1

    unless index
      raise ::ArgumentError, 'Expected matching ' + ::Magnets::Path::Parser::RegexpDelimiter + 
                             ' in "' + descriptor_string + '".'
    end

    regexp_source = descriptor_string.slice!( 0..index )[ 1..-2 ]

    # if we have remaining descriptor we have a fragment, otherwise a full part
    return ::Magnets::Path::
             PathPart.create_part_or_fragment( descriptor_string, 
                                               ::Magnets::Path::PathPart::Regexp, 
                                               ::Magnets::Path::PathPart::Fragment::RegexpFragment, 
                                               multiple_capturing_fragments,
                                               regexp_source )
    
  end
  
  #######################################
  #  self.parse_path_part_for_optional  #
  #######################################
  
  def self.parse_path_part_for_optional( descriptor_string, multiple_capturing_fragments = nil )

    # we were passed |... - we need to look for |
    index = descriptor_string[ 1..-1 ].index( ::Magnets::Path::Parser::OptionalDelimiter ) + 1

    unless index
      raise ::ArgumentError, 'Expected matching ' + ::Magnets::Path::Parser::OptionalDelimiter + 
                             ' in "' + descriptor_string + '".'
    end

    optional_part_descriptor_string = descriptor_string.slice!( 0..index )[ 1..-2 ]

    # optional parts array descriptor
    optional_parts = optional_part_descriptor_string.split( ::Magnets::Path::Parser::
                                                              OptionalPartDelimiter )
    
    # check the first part for name - we assume the rest of the parts are similar
    optional_instance = nil
    if optional_parts[ 0 ].include?( ::Magnets::Path::Parser::OptionalNameDelimiter )
      
      optional_parts.each_with_index do |this_part_string, index|
        optional_parts[ index ] = this_part_string.split( ::Magnets::Path::
                                                            Parser::OptionalNameDelimiter )
      end
      
      # if we have names our descriptor is a hash instead of an array
      optional_parts = Hash[ optional_parts ]

      optional_instance = ::Magnets::Path::
                            PathPart.create_part_or_fragment( descriptor_string, 
                                                              ::Magnets::Path::PathPart::
                                                                NamedOptional, 
                                                              ::Magnets::Path::
                                                                PathPart::Fragment::
                                                                OptionalFragment::
                                                                NamedOptionalFragment, 
                                                              multiple_capturing_fragments,
                                                              optional_parts )
    
    else

      optional_instance = ::Magnets::Path::
                            PathPart.create_part_or_fragment( descriptor_string, 
                                                              ::Magnets::Path::
                                                                PathPart::Optional, 
                                                              ::Magnets::Path::
                                                                PathPart::Fragment::
                                                                OptionalFragment, 
                                                              multiple_capturing_fragments,
                                                              *optional_parts )
      
    end
        
    return optional_instance

  end

  ########################################
  #  self.parse_path_part_for_exclusion  #
  ########################################

  def self.parse_path_part_for_exclusion( descriptor_string, multiple_capturing_fragments = nil )

    # we were passed !... - we need to look for !
    index = descriptor_string[ 1..-1 ].index( ::Magnets::Path::Parser::ExclusionDelimiter ) + 1

    unless index
      raise ::ArgumentError, 'Expected matching ' + ::Magnets::Path::Parser::ExclusionDelimiter + 
                             ' in "' + descriptor_string + '".'
    end
    
    exclusion_name = descriptor_string.slice!( 0..index )[ 1..-2 ]
        
    return ::Magnets::Path::
             PathPart.create_part_or_fragment( descriptor_string, 
                                               ::Magnets::Path::PathPart::Exclusion, 
                                               ::Magnets::Path::
                                                 PathPart::Fragment::ExclusionFragment, 
                                               multiple_capturing_fragments,
                                               exclusion_name )
    
  end

end
