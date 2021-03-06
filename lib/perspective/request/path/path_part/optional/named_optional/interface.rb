# -*- encoding : utf-8 -*-

module ::Perspective::Request::Path::PathPart::Optional::NamedOptional:: NamedOptionalInterface
  
  ################
	#  initialize  #
	################
	
	def initialize( parts_hash )
	  
	  # only overridden to change arity
	  super

  end

	############################
	#  regularize_descriptors  #
	############################
  
  def regularize_descriptors( optional_parts_hash )
    
    @parts_hash = optional_parts_hash
    @name_for_parts_hash = { }
    
    @parts_hash.each do |this_name, this_named_optional_part|

      this_named_optional_part = ::Perspective::Request::Path::PathPart.new( this_named_optional_part )

      @parts_hash[ this_name ] = this_named_optional_part
      @name_for_parts_hash[ this_named_optional_part ] = this_name

    end

    @parts = @parts_hash.values
	  
  end
	
end
