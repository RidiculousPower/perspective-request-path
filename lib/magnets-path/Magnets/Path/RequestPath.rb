
class ::Magnets::Path::RequestPath

  LookAheadStruct = Struct.new( :from_part, :from_definition )

	################
	#  initialize  #
	################
	
	def initialize( path_string, path_definition = nil )
    
    if path_string[ 0 ] == ::Magnets::Path::PathPart::PathDelimiter
      path_string.slice!( 0...1 )
    end
    
    @path_parts = path_string.split( ::Magnets::Path::PathPart::PathDelimiter )

    @current_part = 0
    @current_part_definition = 0
    @matched_part = 0

    @current_fragment = 0    
    @current_part_fragment_index = 0
    @matched_fragments = [ ]
    @matched_fragments_for_definition = { }
	  
    @optional_match_start = [ ]
    @look_ahead_match_start = [ ]
    
    @matched_parts = [ ]
    @matched_parts_for_definition = { }
    
    if path_definition
      attach_to_path_definition( path_definition )
    end
    
	end

	###############################
	#  attach_to_path_definition  #
	###############################
	
	def attach_to_path_definition( path_definition )

    @attached_path = path_definition

    @current_part_definition = 0
    
    @current_fragment = 0

  end
  
	###################
	#  attached_path  #
	###################

  def attached_path
    
    unless @attached_path
      raise RuntimeError, 'RequestPath is missing attached Magnets::Path description instance.'
    end
    
    return @attached_path
    
  end
  
  ##########################
	#  begin_optional_match  #
	##########################
	
  def begin_optional_match
    
    @optional_match_start.push( @current_part )
    
  end

	############################
	#  failed_optional_match!  #
	############################
  
  def failed_optional_match!

    @current_part = @optional_match_start.pop
    
  end

	#############################
	#  matched_optional_match!  #
	#############################

  def matched_optional_match!
    
    @optional_match_start.pop
    
  end

	############################
	#  begin_look_ahead_match  #
	############################
  
  def begin_look_ahead_match( how_far_ahead )
    
    look_ahead_start = ::Magnets::Path::RequestPath::LookAheadStruct.new( @current_part, 
                                                                          @current_part_definition )
    @look_ahead_match_start.push( look_ahead_start )
    
    @current_part += how_far_ahead
    @current_part_definition += how_far_ahead
    
  end

	##########################
	#  end_look_ahead_match  #
	##########################
  
  def end_look_ahead_match( how_far_ahead )
    
    look_ahead_start = @look_ahead_match_start.pop
    
    @current_part -= look_ahead_start.from_part
    @current_part_definition -= look_ahead_start.from_definition

  end
  
	######################
	#  look_ahead_match  #
	######################

  def look_ahead_match( how_far_ahead )
    
    begin_look_ahead_match( how_far_ahead )
    
    if current_part_definition
      matched = current_part_definition.match( self )
    end
    
    end_look_ahead_match
    
    return matched
    
  end
  
	##########################
	#  has_part_definition?  #
	##########################

  def has_part_definition?( how_far_ahead = 0 )
    
    return ( @current_part_definition + how_far_ahead ) < attached_path.count
    
  end

	###########################
	#  count_remaining_parts  #
	###########################
  
  def count_remaining_parts
    
    return @path_parts.count - @current_part
    
  end

	#############################
	#  current_part_definition  #
	#############################
  
  def current_part_definition
    
    return attached_path[ @current_part_definition ]
    
  end
  
	##################
	#  current_part  #
	##################

  def current_part
    
    return @path_parts[ @current_part ]
    
  end
  
	###############
	#  next_part  #
	###############

  def next_part
        
    # advance count
	  @current_part += 1
    @current_part_definition += 1
	  
	  # if we've already matched this part (via look-ahead) advance again
	  while @matched_parts[ @current_part ]
  	  @current_part += 1
      @current_part_definition += 1
    end
    
	  # reset fragment
	  @current_fragment = 0
	  @current_part_fragment_index = 0
    
    return current_part
    
  end

	#################################
	#  current_fragment_definition  #
	#################################
  
	def current_fragment_definition
	  
	  return current_part_definition[ @current_fragment ]
	  
  end

	######################
	#  current_fragment  #
	######################
  
	def current_fragment
	  
	  current_fragment = current_part
	  
	  if @current_part_fragment_index > 0
	    current_fragment = current_fragment.slice( @current_part_fragment_index..-1 )
    end
	  
	  return current_fragment
	  
  end
  
  #############################
	#  has_remaining_fragment?  #
	#############################
  
  def has_remaining_fragment?
    
    return current_part_definition.count > ( @current_fragment + 1 )
    
  end
	
  ##################################
	#  match_fragment_by_look_ahead  #
	##################################
	
  def match_fragment_by_look_ahead
    
    matched_fragment = nil
    
    @current_fragment += 1
    
    if index = current_fragment_definition.look_ahead_match( self )
      matched_fragment = current_fragment.slice( 0...index )
    end

    @current_fragment -= 1
    
    return matched_fragment
    
  end

  ##################################
	#  matched_look_ahead_fragment!  #
	##################################
  
  def matched_look_ahead_fragment!( index, length )
    
    definition = current_fragment_definition
    @matched_fragments[ @current_fragment ] = definition
    @matched_fragments_for_definition[ definition ] = current_fragment.slice( index, length )

  end

	######################
	#  matched_fragment  #
	######################

  def matched_fragment( fragment_definition )
    
    return @matched_fragments_for_definition[ fragment_definition ]
    
  end
  
	##################
	#  matched_part  #
	##################

  def matched_part( part_definition )
    
    return @matched_parts_for_definition[ part_definition ]
    
  end
  
	###################
	#  matched_part!  #
	###################

	def matched_part!
	  
	  # store part matched to definition that matched it
	  definition = current_part_definition
	  @matched_parts[ @current_part ] =  definition
    @matched_parts_for_definition[ definition ] = current_part

    next_part
	  
  end

	###################
	#  next_fragment  #
	###################

  def next_fragment( length )

    # advance count
	  @current_fragment += 1
    @current_part_fragment_index += length
	  
	  # if we've already matched this part (via look-ahead) advance again
    while matched_fragment = @matched_fragments_for_definition[ current_fragment_definition ]
  	  @current_fragment += 1
      @current_part_fragment_index += matched_fragment.length
    end
    
    return current_fragment
    
  end

	#######################
	#  matched_fragment!  #
	#######################

	def matched_fragment!( length )

    definition = current_fragment_definition
    @matched_fragments[ @current_fragment ] = definition
    @matched_fragments_for_definition[ definition ] = current_fragment.slice( 0, length )

    if has_remaining_fragment?
      next_fragment( length )
    end
    
  end

	#####################
	#  matched_failed!  #
	#####################

	def matched_failed!
	  
	  @attached_path = nil
	  
  end

end
