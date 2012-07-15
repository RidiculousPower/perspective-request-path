
class ::Magnets::Path::PathPart::Multiple

  include ::Magnets::Path::PathPart

	################
	#  initialize  #
	################
	
	def initialize( *fragments )
    
    @fragments = [ ]

    fragments.each do |this_fragment_descriptor|

      case this_fragment_descriptor

        when ::Magnets::Path::PathPart::Fragment
          
          add_fragment( this_fragment_descriptor )
        
        when ::String
          
          ::Magnets::Path::Parser.parse_path_part_string( this_fragment_descriptor, self )
        
        else
          
          raise ::ArgumentError, 'Expected ' + self.to_s + ' or string descriptor.'

      end
	  
	  end
	  
	end
	
	##################
	#  add_fragment  #
	##################
	
	def add_fragment( fragment )
	  
	  @fragments.push( fragment )
	  
  end

	###########
	#  count  #
	###########
	
	def count
	  
	  return @fragments.count

  end
	
	########
	#  []  #
	########
	
	def []( index )
    
    return @fragments[ index ]
    
  end
  
end
