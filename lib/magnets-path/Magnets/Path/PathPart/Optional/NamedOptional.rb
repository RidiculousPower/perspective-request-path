
class ::Magnets::Path::PathPart::Optional::NamedOptional < ::Magnets::Path::PathPart::Optional

	################
	#  initialize  #
	################
	
	def initialize( parts_hash )
	  
	  # only overridden to change arity
	  super

  end

	######################
	#  initialize_parts  #
	######################
	
	def initialize_parts( parts_hash )

    @parts_hash = parts_hash
    @name_for_parts_hash = { }
    
    @parts_hash.each do |this_name, this_named_optional_part|

      this_named_optional_part = ::Magnets::Path::PathPart.new( this_named_optional_part )

      @parts_hash[ this_name ] = this_named_optional_part
      @name_for_parts_hash[ this_named_optional_part ] = this_name

    end
	  
    @parts = parts_hash.values
        
	end

end
