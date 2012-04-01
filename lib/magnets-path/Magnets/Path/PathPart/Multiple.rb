
class ::Magnets::Path::PathPart::Multiple

	################
	#  initialize  #
	################
	
	def initialize( *fragments )

    @fragments = ::Magnets::Path::PathPart::Fragment.regularize_fragments( self, *fragments )
	  
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
