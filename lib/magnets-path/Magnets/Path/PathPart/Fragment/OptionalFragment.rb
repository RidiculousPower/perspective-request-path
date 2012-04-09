
class ::Magnets::Path::PathPart::Fragment::OptionalFragment

  include ::Magnets::Path::PathPart::Optional::Interface

  include ::Magnets::Path::PathPart::Fragment

	############################
	#  regularize_descriptors  #
	############################
  
  def regularize_descriptors( *optional_parts )
    
    @parts = [ ]
    
    ::Magnets::Path::PathPart::Fragment.regularize_descriptors( self, *optional_parts )
	  
  end

	######################
	#  initialize_parts  #
	######################
	
	def initialize_parts
	  	      
	  @parts.each do |this_descriptor|
      
      case this_descriptor
        when ::Magnets::Path::PathPart::Fragment::OptionalFragment
          @optional_parts.push( this_descriptor )
        else
          @non_optional_part_count += 1
      end

    end
    
  end

	##################
	#  add_fragment  #
	##################
	
	def add_fragment( fragment )
	  
	  @parts.push( fragment )
	  
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	####################################
	#  match_for_configuration_struct  #
	####################################

  def match_for_configuration_struct( request_path, configuration_struct )
        
    return match_parts_for_configuration_struct( request_path, configuration_struct )
      
  end

	##########################################
	#  match_parts_for_configuration_struct  #
	##########################################
  
  def match_parts_for_configuration_struct( request_path, configuration_struct )
    
    return super( request_path, configuration_struct, ::Magnets::Path::PathPart::Fragment::
                                                        OptionalFragment )
    
  end
  
	#################################
	#  match_for_any_configuration  #
	#################################
  
  def match_for_any_configuration( request_path )
    
    matched = false
    
    # if we have less parts remaining than the minimal match, this instance can't match
	  @configurations.each do |this_configuration|
      
      request_path.begin_optional_fragment_match
      
      if matched = match_for_configuration_struct( request_path, this_configuration )
        request_path.matched_optional_fragment_match!
        break
  	  end

      request_path.failed_optional_fragment_match!
  	  
    end
    
    return matched
    
  end


end
