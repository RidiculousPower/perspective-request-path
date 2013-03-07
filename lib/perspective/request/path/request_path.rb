# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::RequestPath

  FrameStruct = ::Struct.new( :current_index, 
                              :current_definition_index, 
                              :fragment_stack,
                              :matched_for_index,
                              :matched_for_definition )
  
  FragmentFrameStruct = ::Struct.new( :current_slice_index, 
                                      :current_definition_index,
                                      :matched_for_index,
                                      :matched_for_definition )
  
	################
	#  initialize  #
	################
	
	def initialize( path_string, path_definition = nil )
    
    if path_string[ 0 ] == ::Perspective::Request::Path::Parser::PathDelimiter
      path_string.slice!( 0...1 )
    end
    
    @path_parts = path_string.split( ::Perspective::Request::Path::Parser::PathDelimiter )

    # We use a stack of part definition frames and fragment definition frames
    # to keep track of optional and look-ahead matching.
    #
    # The stack permits us to pop the last frame and return to the last context.
    #
    # Stacks can only move forward, meaning a newer frame is either at the same place 
    # or farther forward than the frame before it.
    # 
    @stack = [ ]
        
    if path_definition
      attach_to_path_definition( path_definition )
    end
    
	end

	###############################  Attaching to Path Definition  ###################################

	###############################
	#  attach_to_path_definition  #
	###############################
	
	def attach_to_path_definition( path_definition, reset_request_path = false )
    
    @stack.push( new_frame )

    @attached_path = path_definition
    
    return self
    
  end

	###################
	#  attached_path  #
	###################

  def attached_path
    
    unless @attached_path
      raise ::RuntimeError, self.class.to_s + ' is missing attached ' + ::Perspective::Request::Path.to_s + 
                            ' description instance.'
    end
    
    return @attached_path
    
  end

	#######################################  Path Matching  ##########################################
  
  ###########
	#  match  #
	###########

  def match( path_definition = nil )
    
    if path_definition
      attach_to_path_definition( path_definition )
    end
    
    return attached_path.match( self )
	
	end
	
	##################################  Path Definition Queries  #####################################

  ##########################
	#  has_part_definition?  #
	##########################

  def has_part_definition?( how_far_ahead = 0 )
    
    forward_index = current_frame.current_definition_index + how_far_ahead
    
    return forward_index < attached_path.count
    
  end

	##############################
	#  has_fragment_definition?  #
	##############################

  def has_fragment_definition?( how_far_ahead = 0 )
    
    has_fragment_definition = false
    
    if fragment_frame = current_fragment_frame

      forward_index = current_fragment_frame.current_slice_index + how_far_ahead
      
      has_fragment_definition = ( forward_index < current_part_definition.count )
      
    end
    
    return has_fragment_definition
    
  end

	#############################
	#  current_part_definition  #
	#############################
  
  def current_part_definition
    
    return attached_path[ current_frame.current_definition_index ]
    
  end
  
  #################################
	#  current_fragment_definition  #
	#################################
  
	def current_fragment_definition
	  
	  current_fragment = nil
	  
	  if fragment_frame = current_fragment_frame
	    current_fragment = current_part_definition[ fragment_frame.current_definition_index ]
    end
	  
	  return current_fragment
	  
  end

  ###################################  Path Request Queries  #######################################
	
	##################
	#  current_part  #
	##################

  def current_part
    
    current_value = nil
    
    if frame = current_frame
      current_value = @path_parts[ frame.current_index ]
    end
    
    return current_value
    
  end
  
	###############
	#  next_part  #
	###############

  def next_part
    
    frame = current_frame
        
    # advance count
	  frame.current_index += 1
    frame.current_definition_index += 1

    return current_part
    
  end

	##########################################
	#  declare_current_frame_has_fragments!  #
	##########################################
  
	def declare_current_frame_has_fragments!
	  
	  current_frame.fragment_stack = [ new_fragment_frame ]
	  
	  return self
	  
  end
  
	######################
	#  current_fragment  #
	######################
  
	def current_fragment
    
    fragment = nil
    
    if fragment_frame = current_fragment_frame
    
      if fragment_frame.current_slice_index < current_part.length
      
        fragment = current_part.slice( fragment_frame.current_slice_index..-1 )
    
      end
    
    end
    
	  return fragment
	  
  end
  
  #############################
	#  has_remaining_fragment?  #
	#############################
  
  def has_remaining_fragment?( how_far_ahead = 0 )
    
    has_remaining_fragment = false
    
    if fragment_frame = current_fragment_frame
      
      forward_index = fragment_frame.current_definition_index + how_far_ahead
      has_remaining_fragment = ( forward_index < current_part_definition.count )

    end    
    
    return has_remaining_fragment
    
  end
	
	###########################
	#  count_remaining_parts  #
	###########################
  
  def count_remaining_parts
    
    return @path_parts.count - current_frame.current_index
    
  end

	#####################
	#  remaining_parts  #
	#####################
  
  def remaining_parts
    
    return @path_parts.slice( current_frame.current_index, count - current_frame.current_index )
    
  end
  
  ###############################
	#  count_remaining_fragments  #
	###############################
	
  def count_remaining_fragments

    remaining_count = 0

    if fragment_frame = current_fragment_frame
      
      remaining_count = current_part_definition.count - 
                        current_fragment_frame.current_definition_index
      
    end

    return remaining_count
    
  end

	#########################################  Matching  #############################################

	######################
	#  matched_fragment  #
	######################

  def matched_fragment( fragment_definition )
    
    match_string = nil
    
    fragment_frame = current_fragment_frame
    
    if fragment_frame and fragment_frame.matched_for_definition
      
      match_string = fragment_frame.matched_for_definition[ fragment_definition ]
      
    end
    
    return match_string
    
  end
  
	##################
	#  matched_part  #
	##################

  def matched_part( part_definition )
    
    match_string = nil
    
    frame = current_frame
    
    if frame and frame.matched_for_definition
      
      match_string = frame.matched_for_definition[ part_definition ]
      
    end
    
    return match_string
    
  end
  
	###################
	#  matched_part!  #
	###################

	def matched_part!( how_many_parts = 1 )
	  
	  frame = current_frame

	  frame.matched_for_index ||= { }
	  frame.matched_for_definition ||= { }

    how_many_parts.times do |this_time|
      
      definition = current_part_definition
  	  
  	  frame.matched_for_index[ frame.current_definition_index ] =  definition
  	  frame.matched_for_definition[ definition ] = current_part

      next_part

    end
        
    return self
	  
  end

	###################
	#  next_fragment  #
	###################

  def next_fragment

    fragment_frame = current_fragment_frame

    # advance count
    fragment_frame.current_definition_index += 1
    
    return current_fragment
    
  end

	#######################
	#  matched_fragment!  #
	#######################

	def matched_fragment!( length )

    fragment_frame = current_fragment_frame

    definition = current_fragment_definition
    
    fragment_frame.matched_for_index ||= { }
    fragment_frame.matched_for_definition ||= { }
    
    fragment_frame.matched_for_index[ fragment_frame.current_definition_index ] = definition
    
    matched_fragment = current_fragment.slice( 0, length )
    fragment_frame.matched_for_definition[ definition ] = matched_fragment

    fragment_frame.current_slice_index += length

    if has_remaining_fragment?( 1 )
      next_fragment
    end
    
  end

	###################
	#  match_failed!  #
	###################

	def match_failed!
	  
	  # pop off failed frame
	  @stack.pop
	  
	  if @stack.empty?
  	  @attached_path = nil
    end
	  
  end

	#####################################  Optional Matching  ########################################

  ##########################
	#  begin_optional_match  #
	##########################
	
  def begin_optional_match
    
    @stack.push( new_frame( 0 ) )
    
    return self
    
  end

	############################
	#  failed_optional_match!  #
	############################
  
  def failed_optional_match!

    # return to prior context
    @stack.pop
    
    return self
    
  end

	#############################
	#  matched_optional_match!  #
	#############################

  def matched_optional_match!
    
    merge_frame( @stack.pop, current_frame )
    
    return self
    
  end

  ###################################
	#  begin_optional_fragment_match  #
	###################################
	
  def begin_optional_fragment_match
    
    current_frame.fragment_stack.push( new_fragment_frame( 0 ) )

    return self
    
  end

	#####################################
	#  failed_optional_fragment_match!  #
	#####################################
  
  def failed_optional_fragment_match!

    # return to prior context
    current_frame.fragment_stack.pop

    return self
    
  end

	######################################
	#  matched_optional_fragment_match!  #
	######################################

  def matched_optional_fragment_match!

    merge_fragment_frame( current_frame.fragment_stack.pop, current_fragment_frame )
    
    return self
    
  end

	####################################  Look-Ahead Matching  #######################################

	############################
	#  begin_look_ahead_match  #
	############################
  
  def begin_look_ahead_match( how_far_ahead )
        
    @stack.push( new_frame( how_far_ahead ) )
    
    return self
    
  end

	##########################
	#  end_look_ahead_match  #
	##########################
  
  def end_look_ahead_match
    
    merge_matched_parts_for_frame( @stack.pop, current_frame )
    
    return self

  end

	######################
	#  look_ahead_match  #
	######################

  def look_ahead_match( how_far_ahead )
    
    matched = false
    
    begin_look_ahead_match( how_far_ahead )
    
    if current_part_definition
      matched = current_part_definition.match( self )
    end
    
    end_look_ahead_match
    
    return matched
    
  end

  ###############################
	#  look_ahead_fragment_match  #
	###############################
	
  def look_ahead_fragment_match
    
    matched_fragment = nil
    
    fragment_frame = current_fragment_frame
    
    distance_definition_index_advanced = 1
    
    fragment_frame.current_definition_index += distance_definition_index_advanced
    
    index, length = current_fragment_definition.look_ahead_match( self )
  
    if index and index > 0
    
      end_slice_index = index + length

      matched_fragment = current_fragment.slice( index...end_slice_index )
    
      # we advanced an additional one when we matched
      distance_definition_index_advanced += 1
    
    end

    fragment_frame.current_definition_index -= distance_definition_index_advanced
    
    return index
    
  end

  ##################################
	#  matched_look_ahead_fragment!  #
	##################################
  
  def matched_look_ahead_fragment!( fragment_slice_index, length )
    
    fragment_frame = current_fragment_frame
    
    current_slice_index = fragment_frame.current_slice_index
    
    fragment_frame.current_slice_index = fragment_slice_index

    matched_fragment!( length )
    
    fragment_frame.current_slice_index = current_slice_index

    return self
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	###############
	#  new_frame  #
	###############
  
  def new_frame( how_far_ahead = 0 )
    
    new_part_index = 0
    new_part_definition_index = 0
    
    if frame = current_frame

      new_part_index = frame.current_index + how_far_ahead
      new_part_definition_index = frame.current_definition_index + how_far_ahead
      
    end
    
    return ::Perspective::Request::Path::RequestPath::FrameStruct.new( new_part_index, 
                                                          new_part_definition_index )

  end

	########################
	#  new_fragment_frame  #
	########################

  def new_fragment_frame( how_far_ahead = nil )
    
    new_fragment_index = 0
    new_fragment_definition_index = 0
    
    if how_far_ahead

      fragment_frame = current_fragment_frame

      new_fragment_index = fragment_frame.current_slice_index + how_far_ahead
      new_fragment_definition_index = fragment_frame.current_definition_index + how_far_ahead
    
    end
    
    return ::Perspective::Request::Path::RequestPath::FragmentFrameStruct.new( new_fragment_index, 
                                                                  new_fragment_definition_index )
    
  end

	###################
	#  current_frame  #
	###################
  
	def current_frame
	  
	  return @stack[ -1 ]
	  
  end

	############################
	#  current_fragment_frame  #
	############################
  
	def current_fragment_frame
	  
	  current_fragment_frame = nil
	  
	  if fragment_stack = current_frame.fragment_stack
	    current_fragment_frame = fragment_stack[ -1 ]
	  end
	  
	  return current_fragment_frame
	  
  end
  
	#################
	#  merge_frame  #
	#################
  
  def merge_frame( match_frame, merge_frame )
    
    merge_frame.current_index = match_frame.current_index
    merge_frame.current_definition_index = match_frame.current_definition_index
        
    merge_matched_parts_for_frame( match_frame, merge_frame )
    
  end

	###################################
	#  merge_matched_parts_for_frame  #
	###################################
  
  def merge_matched_parts_for_frame( match_frame, merge_frame )

    # we're done with all of the fragments and preparing to move to the next part

    if merge_frame.matched_for_index
      merge_frame.matched_for_index.merge!( match_frame.matched_for_index )
    else
      merge_frame.matched_for_index = match_frame.matched_for_index
    end

    if merge_frame.matched_for_definition
      merge_frame.matched_for_definition.merge!( match_frame.matched_for_definition )
    else
      merge_frame.matched_for_definition = match_frame.matched_for_definition
    end

    # if we matched a frame we matched all our parts for the frame which means all our fragments
    # so we only have to merge fragment matches from the last fragment frame (which has merged down)
    if match_fragment_stack = match_frame.fragment_stack
      # we might have a fragment stack
      if merge_fragment_stack = merge_frame.fragment_stack
        # merge down all of our fragment frames and then merge in our match frame
        until merge_fragment_stack.count == 1
          merge_fragment_frame( merge_fragment_stack[ -1 ], merge_fragment_stack.shift )
        end
        # if we matched we already finished the fragments in our part, so only one frame results
        merge_fragment_frame( merge_fragment_stack[ -1 ], match_fragment_stack[ 0 ] )
      else
        merge_frame.fragment_stack = match_fragment_stack
      end
    end
    
  end

	##########################
	#  merge_fragment_frame  #
	##########################
  
  def merge_fragment_frame( match_frame, merge_frame )
    
    merge_frame.current_slice_index = match_frame.current_slice_index

    new_definition_index = match_frame.current_definition_index
    merge_frame.current_definition_index = new_definition_index
        
    merge_matched_parts_for_fragment_frame( match_frame, merge_frame )
    
  end
  
  ############################################
	#  merge_matched_parts_for_fragment_frame  #
	############################################
  
  def merge_matched_parts_for_fragment_frame( match_frame, merge_frame )

    new_matched_fragments = match_frame.matched_for_index
    if merge_frame.matched_for_index
      merge_frame.matched_for_index.merge!( new_matched_fragments )
    else
      merge_frame.matched_for_index = new_matched_fragments
    end

    new_matched_for_definition = match_frame.matched_for_definition
    if merge_frame.matched_for_definition
      merge_frame.matched_for_definition.merge!( new_matched_for_definition )
    else
      merge_frame.matched_for_definition = new_matched_for_definition
    end    
	
	end
	
end
