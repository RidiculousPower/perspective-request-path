
class ::Perspective::Request::Path::Basepath

  include ::Perspective::Request::Path::PathPart
  
	################
	#  initialize  #
	################
	
	def initialize( *basepath_descriptors )
    
    @basepaths = ::Perspective::Request::Path::PathPart.regularize_descriptors( *basepath_descriptors )
    
	end

	###########
	#  match  #
	###########
	
	def match( request_path )
	  
	  matched = false
	  
	  @basepaths.each do |this_path_descriptor|
	    break unless matched = this_path_descriptor.match( request_path )
    end

	  return matched
	  
  end

end
