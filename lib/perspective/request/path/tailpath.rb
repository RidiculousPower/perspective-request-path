# -*- encoding : utf-8 -*-

class ::Perspective::Request::Path::Tailpath

  include ::Perspective::Request::Path::PathPart

	################
	#  initialize  #
	################
	
	def initialize( *tailpath_descriptors )
    
    @basepaths = ::Perspective::Request::Path::PathPart.regularize_descriptors( *tailpath_descriptors )
    
	end

  #####################
  #  match_tailpaths  #
  #####################

	def match_tailpaths( request_path )

		matched_tailpath = nil

		# get path parts array from request path
		path_parts = path_fragments_for_path( request_path )

		# this viewpath can have multiple paths that match
		# iterate through path parts to check against request path
		tailpaths.each do |this_tailpath_descriptor_array|
			break if matched_tailpath = match_tailpath_descriptor( this_tailpath_descriptor_array.dup, 
			                                                       path_parts.dup )
		end

		return matched_tailpath

	end
	
  ###############################
  #  match_tailpath_descriptor  #
  ###############################

	def match_tailpath_descriptor( descriptor_elements, path_parts )
		
		# reverse descriptor elements and path parts and match basepath
		matched_path_parts = match_basepath_descriptor( descriptor_elements.reverse, 
		                                                path_parts.reverse )
		
		if matched_path_parts
		  matched_path_parts = matched_path_parts.reverse
    end
    
		return matched_path_parts
		
	end

end
