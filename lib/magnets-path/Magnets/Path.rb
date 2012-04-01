
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

  ########################
  #  match_request_path  #
  ########################

  def match_request_path( request_path )
    
    matched = false
    
    parts.each do |this_part|
      
      break unless matched = this_part.match( request_path )
      
    end
    
    return matched
    
  end

end
