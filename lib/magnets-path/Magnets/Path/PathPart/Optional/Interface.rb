
module ::Magnets::Path::PathPart::Optional::Interface

  include ::Magnets::Path::PathPart
  
  attr_reader :configurations

  SubOptionStruct = ::Struct.new( :parent_optional_part, :count, :sub_options )

	################
	#  initialize  #
	################
	
	def initialize( *optional_parts )
    
    @optional_parts = [ ]

    @non_optional_part_count = 0
        
    regularize_descriptors( *optional_parts )
    initialize_parts
        
    # keep configurations sorted by struct.count with longest first
    @configurations = ::CompositingArray::Sorted::Unique.new do |this_object|
      this_object.count
    end.reverse!

    no_options_struct = ::Magnets::Path::PathPart::Optional::Interface::
                          SubOptionStruct.new( self, @non_optional_part_count )
    @configurations.push( no_options_struct )
    
    unless @optional_parts.empty?
      initialize_sub_option_combinations
    end
    
	end

	############################
	#  regularize_descriptors  #
	############################
  
  def regularize_descriptors( *optional_parts )
    
    @parts = ::Magnets::Path::PathPart.regularize_descriptors( *optional_parts )
	  
  end
  
	######################
	#  initialize_parts  #
	######################
	
	def initialize_parts
	  	      
	  @parts.each do |this_descriptor|
      
      case this_descriptor
        when ::Magnets::Path::PathPart::Optional
          @optional_parts.push( this_descriptor )
        else
          @non_optional_part_count += 1
      end

    end
    
  end
	
	########################################
	#  initialize_sub_option_combinations  #
	########################################
	
	def initialize_sub_option_combinations
  
    if @optional_parts.count > 1
  
      # We have multiple options - we need every combination when taking 1 from each.
      # Array#product gives us what we need but we need to do setup first.
      
      # each product is a configuration
      arrays_for_product = arrays_for_cross_product_of_optional_parts
      base_product_array = arrays_for_product[ 0 ]
      remaining_product_arrays = arrays_for_product[ 1..-1 ]
      base_product_array.product( *remaining_product_arrays ) do |this_cross_product|

        new_configuration_struct = ::Magnets::Path::PathPart::Optional::Interface::
                                     SubOptionStruct.new( self, @non_optional_part_count )

        new_configuration_struct.sub_options = { }

        this_cross_product.each_with_index do |configuration_index, option_index|
                    
          if configuration_index
          
            this_sub_option = @optional_parts[ option_index ]

            this_sub_configuration_struct = this_sub_option.configurations[ configuration_index ]

            new_configuration_struct.count += this_sub_configuration_struct.count
            new_configuration_struct.sub_options[ this_sub_option ] = configuration_index

          end
                    
        end

        @configurations.push( new_configuration_struct )

      end

    else

      # We have only one option
      sub_option = @optional_parts[ 0 ]
      sub_option.configurations.each_with_index do |this_sub_configuration_struct, 
                                                    configuration_index|
        
        this_configuration_count = @non_optional_part_count + this_sub_configuration_struct.count
        
        this_sub_options_hash = { sub_option => configuration_index }
        this_new_configuration_struct = ::Magnets::Path::PathPart::Optional::Interface::
                                          SubOptionStruct.new( self, 
                                                               this_configuration_count,
                                                               this_sub_options_hash )

        @configurations.push( this_new_configuration_struct )

      end
      
    end
    
  end
  
	###########
	#  match  #
	###########
	
	def match( request_path, configuration = nil )
	  
	  matched = false
	  
	  # if we have a combination we are matching only that combination for request path
	  # otherwise we are looking through all combinations for one that matches
	  if configuration
	    
	    matched = match_for_configuration( request_path, configuration )
	    
    else
	  
	    matched = match_for_any_configuration( request_path )
	  	  
	  end
	  
	  return matched
	  
  end

  ########
  #  []  #
  ########

  def []( index )
    
    return @parts[ index ]
    
  end

  ###########
  #  count  #
  ###########

  def count
    
    return @parts.count
    
  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	#################################
	#  match_for_any_configuration  #
	#################################
  
  def match_for_any_configuration( request_path )
    
    matched = false
    
    # if we have less parts remaining than the minimal match, this instance can't match
    unless request_path.count_remaining_parts < @non_optional_part_count
    
  	  @configurations.each do |this_configuration|
        
        request_path.begin_optional_match

        if matched = match_for_configuration_struct( request_path, this_configuration )
          request_path.matched_optional_match!
          break
    	  end

      end

    end
    
    return matched
    
  end

	#############################
	#  match_for_configuration  #
	#############################

  def match_for_configuration( request_path, configuration_index )
      
    configuration_struct = @configurations[ configuration_index ]
    
    return match_for_configuration_struct( request_path, configuration_struct )
    
  end

	####################################
	#  match_for_configuration_struct  #
	####################################

  def match_for_configuration_struct( request_path, configuration_struct )
    
    matched = false
    
    # if we have less parts remaining than the count for this configuration, 
    # this configuration can't match
    unless request_path.count_remaining_parts < configuration_struct.count
      
      # Do a look-ahead match - we want to see if this option set matching could result 
      # in a successful path match.
      
      if ! request_path.has_part_definition?( configuration_struct.count )  or 
         request_path.look_ahead_match( configuration_struct.count )
      
        matched = match_parts_for_configuration_struct( request_path, configuration_struct )
      
      end
      
    end
    
    return matched
      
  end

	##########################################
	#  match_parts_for_configuration_struct  #
	##########################################
  
  def match_parts_for_configuration_struct( request_path, configuration_struct )
    
    matched = false

    @parts.each do |this_part|

      case this_part

        when ::Magnets::Path::PathPart::Optional

          break unless matched = match_optional_configuration( request_path, 
                                                               configuration_struct, 
                                                               this_part )
  
        else

          break unless matched = this_part.match( request_path )

      end
    
    end

    return matched
    
  end
  
  ##################################
	#  match_optional_configuration  #
	##################################
	
  def match_optional_configuration( request_path, configuration_struct, part )
    
    matched = false
    
    # if we have no sub-options we ignore optional part
    # similarly if sub-option is not specified
    if configuration_struct.sub_options

      # check if this sub-option is included in this configuration
      if sub_option_configuration_index = configuration_struct.sub_options[ part ]

        matched = part.match( request_path, sub_option_configuration_index )

      else

        matched = true

      end
    
    else
      
      matched = true

    end
    
    return matched
    
  end

	################################################
	#  arrays_for_cross_product_of_optional_parts  #
	################################################

  def arrays_for_cross_product_of_optional_parts
  
    arrays_for_product = [ ]

    @optional_parts.each do |this_optional_part|
        
      this_option_configurations = [ nil ]
    
      this_optional_part.configurations.each_with_index do |this_configuration_struct, index|
        this_option_configurations.push( index )
      end
    
      arrays_for_product.push( this_option_configurations )
  
    end
    
    return arrays_for_product
    
  end

end
