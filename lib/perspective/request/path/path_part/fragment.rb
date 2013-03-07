# -*- encoding : utf-8 -*-

module ::Perspective::Request::Path::PathPart::Fragment

  ##############
  #  self.new  #
  ##############
  
  # expects single path fragment (no path delimiter)
  def self.new( path_descriptor, multiple_capturing_fragments )
    
    descriptor_instance = nil
    
    case path_descriptor
		  
			when ::String
			  
		    ::Perspective::Request::Path::Parser.parse_path_part_string( path_descriptor, 
		                                                    multiple_capturing_fragments )
			  
		  when ::Symbol

        descriptor_instance = ::Perspective::Request::Path::PathPart::Fragment::
                                VariableFragment.new( path_descriptor )
        multiple_capturing_fragments.add_fragment( descriptor_instance )
        
			# * regexp for individual or multiple parts
		  when ::Regexp

        descriptor_instance = ::Perspective::Request::Path::PathPart::Fragment::
                                RegexpFragment.new( path_descriptor )
        multiple_capturing_fragments.add_fragment( descriptor_instance )
				
			# * arrays denote optional portions 
			#   ( [ :optional_var, :optional_var, [ :optional_var ], :optional_var ] )
	    when ::Array

        descriptor_instance = ::Perspective::Request::Path::PathPart::Fragment::
                                OptionalFragment.new( *path_descriptor )
        multiple_capturing_fragments.add_fragment( descriptor_instance )

			# * hashes denote named optional portions 
			#   ( { :optional_name => :optional_var, :optional_name => 'part' } )
  		when ::Hash

        descriptor_instance = ::Perspective::Request::Path::PathPart::Fragment::OptionalFragment::
                                NamedOptionalFragment.new( path_descriptor )
        multiple_capturing_fragments.add_fragment( descriptor_instance )

		end
    
    return path_descriptor
    
  end

	#################################
	#  self.regularize_descriptors  #
	#################################
  
  def self.regularize_descriptors( path_part, *optional_parts )
    
    optional_parts.each do |this_path_descriptor|

      case this_path_descriptor

        when ::Perspective::Request::Path::PathPart::Fragment
          
          path_part.add_fragment( this_path_descriptor )
                
        else
          
          ::Perspective::Request::Path::PathPart::Fragment.new( this_path_descriptor, path_part )

      end
            
    end
    
    return path_part
	  
  end

end
