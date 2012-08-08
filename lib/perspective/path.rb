
begin ; require 'development' ; rescue ::LoadError ; end

require 'perspective/configuration'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

class ::Perspective::Request::Path

  #########################################
  #  self.is_path_or_part_or_descriptor?  #
  #########################################
  
  def self.is_path_or_part_or_descriptor?( object )
    
    is_path_or_part = false
    
    unless is_path_or_part = ::Perspective::Request::Path::PathPart.is_part_or_descriptor?( object )
      is_path_or_part = is_a?( self )
    end
    
    return is_path_or_part
    
  end

  ################
  #  initialize  #
  ################
  
  def initialize( *path_parts )
    
    @parts = ::Perspective::Request::Path::PathPart.regularize_descriptors( *path_parts )

  end
  
  ########
  #  []  #
  ########
  
  def []( path_part_index )
    
    return @parts[ path_part_index ]
    
  end

  ###########
  #  parts  #
  ###########
  
  attr_reader :parts
  
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

          when ::Perspective::Request::Path::PathPart::Optional
            
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
