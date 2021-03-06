# -*- encoding : utf-8 -*-

module ::Perspective::Request::Path::PathPart
  
  ##############
  #  self.new  #
  ##############
  
  # expects single path part (no path delimiter)
  def self.new( path_descriptor )
    
    descriptor_instance = nil
    
    case path_descriptor
		  
			when ::String
			  
		    descriptor_instance = ::Perspective::Request::Path::Parser.parse_path_part_string( path_descriptor )
			  
		  when ::Symbol

        descriptor_instance = ::Perspective::Request::Path::PathPart::Variable.new( path_descriptor )

			# * regexp for individual or multiple parts
		  when ::Regexp

        descriptor_instance = ::Perspective::Request::Path::PathPart::Regexp.new( path_descriptor )
				
			# * arrays denote optional portions 
			#   ( [ :optional_var, :optional_var, [ :optional_var ], :optional_var ] )
	    when ::Array

        descriptor_instance = ::Perspective::Request::Path::PathPart::Optional.new( *path_descriptor )

			# * hashes denote named optional portions 
			#   ( { :optional_name => :optional_var, :optional_name => 'part' } )
  		when ::Hash

        descriptor_instance = ::Perspective::Request::Path::PathPart::Optional::
                                NamedOptional.new( path_descriptor )

      else
        
        if is_part_or_descriptor?( path_descriptor )
          descriptor_instance = path_descriptor
        else
          raise ::ArgumentError, path_descriptor.inspect + ' does not appear to be a valid ' + 
                self.to_s + ' or descriptor.'
        end
		
		end
    
    return descriptor_instance
    
  end

  #################################
  #  self.is_part_or_descriptor?  #
  #################################
  
  def self.is_part_or_descriptor?( object )

    is_path_or_part = false
    
    case object
		  
			when ::String, ::Symbol, ::Regexp, ::Array, self

        is_path_or_part = true
        
    end
    
    return is_path_or_part
    
  end

  #################################
  #  self.regularize_descriptors  #
  #################################
  
  def self.regularize_descriptors( *descriptors )

    regularized_descriptors = [ ]

    descriptors.each do |this_path_descriptor|

      case this_path_descriptor

        when ::Perspective::Request::Path::PathPart
          
          regularized_descriptors.push( this_path_descriptor )
        
        when ::String
          
          if this_path_descriptor.empty?
            
            regularized_descriptors.push( ::Perspective::Request::Path::PathPart::Empty.new )
            
          else
          
            descriptors_for_string = ::Perspective::Request::Path::
                                       Parser.parse_string_for_descriptors( this_path_descriptor )
            regularized_descriptors.concat( descriptors_for_string )
          end
          
        else
          
          regularized_descriptors.push( new( this_path_descriptor ) )

      end
            
    end
    
    return regularized_descriptors

  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##################################
  #  self.create_part_or_fragment  #
  ##################################
  
  def self.create_part_or_fragment( descriptor_string, 
                                    part_class, 
                                    fragment_class, 
                                    multiple_capturing_fragments = nil,
                                    *part_creation_parameters )

    instance = nil

    # if we have remaining descriptor we have a fragment, otherwise a full part
    if descriptor_empty = descriptor_string.empty? and ! multiple_capturing_fragments

      instance = part_class.new( *part_creation_parameters )    

    else

      unless multiple_capturing_fragments
        multiple_capturing_fragments = ::Perspective::Request::Path::PathPart::Multiple.new
      end
      
      fragment_instance = fragment_class.new( *part_creation_parameters )
      
      multiple_capturing_fragments.add_fragment( fragment_instance )
      
      unless descriptor_empty
        ::Perspective::Request::Path::Parser.parse_path_part_string( descriptor_string, 
                                                        multiple_capturing_fragments )
      end
      
      instance = multiple_capturing_fragments

    end
    
    return instance
    
  end
  
  
end
