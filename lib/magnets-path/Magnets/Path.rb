
class ::Magnets::Path

  include ::Magnets::Bindings

  attr_reader :parts

  ################
  #  initialize  #
  ################
  
  def initialize( *path_parts )
    
    @parts = ::Magnets::Path::PathPart.regularize_descriptors( *path_parts )

  end
  
  ########
  #  []  #
  ########
  
  def []( path_part_index )
    
    return @parts[ path_part_index ]
    
  end
  
  ###########
  #  count  #
  ###########
  
  def count
    
    return @parts.count
    
  end

  ###########
  #  match  #
  ###########

  def match( request_path )
    
    matched = false
    
    parts.each do |this_part|
      
      if request_path.matched_part( this_part )

        matched = true
        
      else
      
        case this_part

          when ::Magnets::Path::PathPart::Optional
            
            # optional parts can fail without implicating match status
            if this_part.match( request_path )
              matched = true
            end
            
          else

            break unless matched = this_part.match( request_path )

        end
        
      end
            
    end
    
    return matched
    
  end

end
