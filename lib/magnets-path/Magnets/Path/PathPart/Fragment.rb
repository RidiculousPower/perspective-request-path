
module ::Magnets::Path::PathPart::Fragment

  ###############################
  #  self.regularize_fragments  #
  ###############################
  
  def self.regularize_fragments( path_part, *descriptors )
    
    regularized_fragments = [ ]
    
    descriptors.each do |this_fragment_descriptor|

      case this_fragment_descriptor

        when ::Magnets::Path::PathPart::Fragment
          
          regularized_fragments.push( this_fragment_descriptor )
        
        when ::String
          
          fragments = parse_path_part_string_for_descriptors( this_fragment_descriptor, path_part )
          regularized_fragments.concat( fragments )
        
        else
          
          raise ::ArgumentError, 'Expected ' + self.to_s + ' or string descriptor.'

      end
            
    end
    
    return regularized_fragments
    
  end
  
end
