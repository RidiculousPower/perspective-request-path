# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::PathPart::Fragment::OptionalFragment

  include ::Perspective::Request::Path::PathPart::Optional::OptionalInterface

  include ::Perspective::Request::Path::PathPart::Fragment

	############################
	#  regularize_descriptors  #
	############################
  
  def regularize_descriptors( *optional_parts )
    
    @parts = [ ]
    
    # fragments are added via add_fragment as they are regularized, 
    # so return value is not important
    ::Perspective::Request::Path::PathPart::Fragment.regularize_descriptors( self, *optional_parts )
	  
  end

	######################
	#  initialize_parts  #
	######################
	
	def initialize_parts
	  	      
	  @parts.each do |this_descriptor|
      
      case this_descriptor
        when ::Perspective::Request::Path::PathPart::Fragment::OptionalFragment
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
        
    matched = false
    
    if ! request_path.has_fragment_definition?( configuration_struct.count )  or 
       request_path.look_ahead_fragment_match
      
      matched = match_parts_for_configuration_struct( request_path, configuration_struct )
    
    end
        
    return matched
      
  end

	##########################################
	#  match_parts_for_configuration_struct  #
	##########################################
  
  def match_parts_for_configuration_struct( request_path, configuration_struct )
    
    matched = false
    
    @parts.each do |this_fragment|

      case this_fragment

        when ::Perspective::Request::Path::PathPart::Fragment::OptionalFragment

          break unless matched = match_optional_configuration( request_path, 
                                                               configuration_struct, 
                                                               this_fragment )
  
        else

          if request_path.current_fragment
            break unless matched = this_fragment.match( request_path )
          else
            matched = false
            break
          end


      end
    
    end

    return matched
    
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

  ######################
	#  look_ahead_match  #
	######################
	
  def look_ahead_match( request_path )
    
    index = nil
    match_length = nil
    
    # looking-ahead to match; we need to look ahead again
    
    if ! request_path.has_fragment_definition?( 1 ) or
       request_path.look_ahead_fragment_match
	  
	    if match( request_path )
	      
	      fragment_frame = current_fragment_frame
	      
	      full_matched_optional_fragment = ''
	      
	      fragment_frame.matched_for_index.each do |this_index, this_fragment_definition|
	        
	        this_matched_fragment = fragment_frame.matched_for_definition[ this_fragment_definition ]
	        
	        full_matched_optional_fragment << this_matched_fragment
	        
        end
	      
      end
	    
  	  if index = request_path.current_fragment.index( @constant_value )

  	    request_path.matched_look_ahead_fragment!( index, @constant_value.length )

  	  end

    end
    
	  return index, match_length
    
  end

end
