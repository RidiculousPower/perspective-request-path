
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rmagnets View Path  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class ::Rmagnets::ViewPath

	attr_accessor	:name
	attr_writer		:scheme, :method, :host, :ip, :port, :referer, :user_agent
	attr_reader		:schemes, :request_methods, :hosts, :ips, :ports, :referers, :user_agents, 
								:paths, :basepaths, :tailpaths, :live_configuration_proc, :render_stack

	# path strings with %name% are converted to :name
	VariableDelimiter		= '%'
	# path strings with #regexp# are converted to /regexp/
	RegexpDelimiter			= '#'
	# path strings that end with * capture all end paths
	AnyPathDelimiter		= '*'

	RenderStackBindingStruct = Struct.new( :name, :view_class, :live_configuration_proc )
	RenderStackViewStruct    = Struct.new( :view_class, :live_configuration_proc )

	################
  #  initialize  #
  ################

  def initialize( name = nil )

		@name 										= name

		@schemes 									= [ ]
		@request_methods 					= [ ]
		@hosts 										= [ ]
		@ips 											= [ ]
		@ports 										= [ ]
		@referers 								= [ ]
		@user_agents 							= [ ]

		@paths 										= [ ]
		@basepaths 								= [ ]
		@tailpaths 								= [ ]

		@matched_path_variables		= [ ]
		@render_stack							= [ ]
		
		self.name                 = name

	end
	
	############
  #  scheme  #
  ############

  def scheme( *schemes )
		
		@schemes.concat( schemes ).uniq!
		
		return self
		
  end

	###################
  #  delete_scheme  #
  ###################

  def delete_scheme( *schemes )
		
		@schemes -= schemes
		
		return self
		
  end

	####################
  #  request_method  #
  ####################

  def request_method( *request_methods )
		
		if request_methods[ 0 ].is_a?( Array )
			@request_methods = request_methods[ 0 ]
		else
		  update_methods = request_methods.collect { |this_method| this_method.to_s.upcase.to_sym }
			@request_methods.concat( update_methods ).uniq!
		end
		
		return self
		
  end

	#########
  #  get  #
  #########

  def get
	
		request_method( :GET )
		
		return self
		
  end

	#########
  #  put  #
  #########

  def put
	
		request_method( :PUT )
		
		return self
		
  end

	##########
  #  post  #
  ##########

  def post
	
		request_method( :POST )
		
		return self
		
  end

	############
  #  delete  #
  ############

  def delete
	
		request_method( :DELETE )
		
		return self
		
  end

	###########################
  #  delete_request_method  #
  ###########################

	def delete_request_method( *request_methods )
		
		@request_methods -= request_methods.collect { |this_method| this_method.to_s.upcase.to_sym }
		
		return self
		
	end

	##########
  #  host  #
  ##########

  def host( *hosts )
		
		@hosts.concat( hosts ).uniq!
		
		return self
		
  end
	alias :hostname :host

	#################
  #  delete_host  #
  #################

  def delete_host( *hosts )
	
		@hosts -= hosts
		
		return self
		
	end
	alias :delete_hostname :delete_host
	
	########
  #  ip  #
  ########

  def ip( *ips )
		
		@ips.concat( ips ).uniq!
		
		return self
		
  end
	alias :address :ip

	###############
  #  delete_ip  #
  ###############

  def delete_ip( *ips )
		
		@ips -= ips
		
		return self
		
	end
	
	##########
  #  port  #
  ##########

  def port( *ports )
		
		@ports.concat( ports ).uniq!
		
		return self
		
  end

	#################
  #  delete_port  #
  #################

  def delete_port( *ports )
		
		@ports -= ports
		
		return self
		
	end
	
	#############
  #  referer  #
  #############

  def referer( *referers )
		
		@referers.concat( referers ).uniq!

		return self
		
  end

	####################
  #  delete_referer  #
  ####################

  def delete_referer( *referers )
		
		@referers -= referers
		
		return self
		
	end
	
	################
  #  user_agent  #
  ################

  def user_agent( *user_agents )
		
		@user_agents.concat( user_agents ).uniq!
		
		return self
		
  end

	#######################
  #  delete_user_agent  #
  #######################

  def delete_user_agent( *user_agents )
	
	 	@user_agents -= user_agents
	
		return self
	
	end
	
	##########
  #  path  #
  ##########

  def path( *path_parts )

		@paths.push( regularized_path_parts( path_parts ) )
		
		return self
		
  end

	#################
  #  clear_paths  #
  #################

  def clear_paths

		@paths = [ ]
		
		return self

	end
	
	#################
  #  delete_path  #
  #################

  def delete_path( index )
		
		@paths.delete_at( index )
		
		return self
		
	end

	##############
  #  basepath  #
  ##############

  def basepath( *path_parts )

		@basepaths.push( regularized_path_parts( path_parts ) )
		
		return self

	end
	
	#####################
  #  delete_basepath  #
  #####################

  def delete_basepath( index )
	
		@basepaths.delete_at( index )
	
	end
	
	##############
  #  tailpath  #
  ##############

  def tailpath( *path_parts )

		@tailpaths.push( regularized_path_parts( path_parts ) )
		
		return self

	end
	
	#####################
  #  delete_tailpath  #
  #####################

  def delete_tailpath( index )
	
		@tailpaths.delete_at( index )
	
	end
	
	
	##########
  #  bind  #
  ##########

  def binding( binding_name, view_class, & live_configuration_proc )

		@render_stack.push( RenderStackBindingStruct.new( binding_name, view_class, live_configuration_proc ) )
		
		return self
		
	end

	####################
  #  delete_binding  #
  ####################

  def delete_binding( index )
		
		@render_stack.delete_at( index )
		
		return self

	end
	
	##########
  #  view  #
  ##########

  def view( view_class, & live_configuration_proc )

		@render_stack.push( RenderStackViewStruct.new( view_class, live_configuration_proc ) )

		return self
		
  end

	#################
  #  delete_view  #
  #################

  def delete_view( index )
		
		@render_stack.delete_at( index )
		
		return self

	end

	#############################
  #  match_non_path_elements  #
  #############################

  def match_non_path_elements( request )

		matched = false

		if	match_scheme( request.scheme )					and
				request_request_method( request.request_method )	and
				match_host( request.host )							and
				match_ip( request.ip )									and
				match_port( request.port )							and
				match_referer( request.referer )				and
				match_user_agent( request.user_agent )

			matched = true
			
		end

		return matched

	end
	
	##################
  #  match_scheme  #
  ##################
	
	def match_scheme( request_scheme )
		
		matched_scheme = false
		
		if @schemes.empty? or @schemes.include?( request_scheme )
			matched_scheme = true
		end
		
		return matched_scheme
		
	end

	##################
  #  match_method  #
  ##################

	def request_request_method( request_method )

		matched_method = false
		
		if @request_methods.empty? or @request_methods.include?( request_method )
			matched_method = true
		end
		
		return matched_method
	
	end

	################
  #  match_host  #
  ################

	def match_host( request_host )
	
		matched_host = false
		
		if @hosts.empty? or @hosts.include?( request_host )
			matched_host = true
		end
		
		return matched_host
	
	end

	##############
  #  match_ip  #
  ##############
	
	def match_ip( request_ip )
	
		matched_ip = false
		
		if @ips.empty? or @ips.include?( request_ip )
			matched_ip = true
		end
		
		return matched_ip
	
	end

	################
  #  match_port  #
  ################

	def match_port( request_port )
	
		matched_port = false
		
		if @ports.empty? or @ports.include?( request_port )
			matched_port = true
		end
		
		return matched_port
	
	end

	###################
  #  match_referer  #
  ###################

	def match_referer( request_referer )
	
		matched_referer = false
		
		if @referers.empty? or @referers.include?( request_referer )
			matched_referer = true
		end
		
		return matched_referer
	
	end

	######################
  #  match_user_agent  #
  ######################

	def match_user_agent( request_user_agent )
	
		matched_user_agent = false
		
		if @user_agents.empty? or @user_agents.include?( request_user_agent )
			matched_user_agent = true
		end
		
		return matched_user_agent
	
	end	
	
  #################
  #  match_paths  #
  #################

	def match_paths( request_path )
		
		matched_path = nil

		# get path parts array from request path
		path_parts = path_fragments_for_path( request_path )

		# this viewpath can have multiple paths that match
		# iterate through path parts to check against request path
		paths.each do |this_path_descriptor_array|
			break if matched_path = match_path_descriptor( this_path_descriptor_array.dup, path_parts.dup )
		end

		return matched_path
		
	end

  ###########################
  #  match_path_descriptor  #
  ###########################

	def match_path_descriptor( descriptor_elements, path_parts )

		# if we start with no descriptors and no path parts we match '' or '/' to '/'
		if descriptor_elements.empty? and path_parts.empty?

			matched_path_parts = [ '/' ]

		else
			
			matched_path_parts = match_basepath_descriptor( descriptor_elements, path_parts )

			matched_path_parts = nil if descriptor_elements.empty? and ! path_parts.empty?
			
		end
		
		return matched_path_parts
		
	end

  #####################
  #  match_basepaths  #
  #####################

	def match_basepaths( request_path )

		matched_basepath = nil

		# get path parts array from request path
		path_parts = path_fragments_for_path( request_path )

		# this viewpath can have multiple paths that match
		# iterate through path parts to check against request path
		basepaths.each do |this_basepath_descriptor_array|
			break if matched_basepath = match_basepath_descriptor( this_basepath_descriptor_array.dup, path_parts.dup )
		end

		return matched_basepath

	end
	
  ###############################
  #  match_basepath_descriptor  #
  ###############################

	def match_basepath_descriptor( descriptor_elements, path_parts )
		
		matched_path_parts = [ ]

		failed = false

		# this viewpath can have multiple paths that match; first one works
		while this_descriptor = descriptor_elements.shift
			if ( path_parts.empty?  and 
				   ! this_descriptor.is_a?( Rmagnets::ViewPath::PathPart::AnyParts ) ) or 
				 ! this_descriptor.match_request( descriptor_elements, path_parts )

				# we ran out of parts but still have descriptors
				failed = true
				break

			else

				matched_path_parts.concat( this_descriptor.matched_paths )

			end
		end
		
		matched_path_parts = nil if matched_path_parts.empty? or failed
		
		return matched_path_parts
		
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
			break if matched_tailpath = match_tailpath_descriptor( this_tailpath_descriptor_array.dup, path_parts.dup )
		end

		return matched_tailpath

	end
	
  ###############################
  #  match_tailpath_descriptor  #
  ###############################

	def match_tailpath_descriptor( descriptor_elements, path_parts )
		
		# reverse descriptor elements and path parts and match basepath
		matched_path_parts = match_basepath_descriptor( descriptor_elements.reverse, path_parts.reverse )
		
		matched_path_parts = matched_path_parts.reverse if matched_path_parts

		return matched_path_parts
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	#############################
  #  path_fragments_for_path  #
  #############################
  
	def path_fragments_for_path( request_path )
		
		# we modify a split array of parts rather than the path string
		remaining_request_path_parts = request_path.split( '/' )
		# if the path string starts with '/' the first item on the array will be ''
		remaining_request_path_parts.shift if request_path[ 0 ] == '/'
		
		return remaining_request_path_parts
		
	end

	############################
  #  regularized_path_parts  #
  ############################

	def regularized_path_parts( path_parts )
		
		regularized_path_parts = [ ]
		
		path_parts.each do |this_part|

			if	this_part.is_a?( Symbol )

				regularized_path_parts.push( Rmagnets::ViewPath::PathPart::Variable.new( this_part ) )

			# * regexp for individual or multiple parts
			elsif	this_part.is_a?( Regexp )

				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::RegularExpression ) )
						
			# * arrays denote optional portions ( [ :optional_var, :optional_var, [ :optional_var ], :optional_var ] )
			elsif this_part.is_a?( Array )

				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::OptionalPart ) )

			# * hashes denote named optional portions ( { :optional_name => :optional_var, :optional_name => 'part' } )
			elsif this_part.is_a?( Hash )

				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::OptionalPart::Named ) )

			# * individual and multiple path fragment ( some/path/to/somewhere )
			else
				
				regularized_path_parts.concat( parse_path_fragment( this_part ) )
				
			end

		end
		
		return regularized_path_parts
		
	end

  #########################
  #  parse_path_fragment  #
  #########################

	def parse_path_fragment( path_fragment )
		
		regularized_path_parts = [ ]
		
		path_fragment.split( '/' ).each do |this_part|

			# if we have "" (which happens when '/' is at either end)
			if this_part.empty?

				next
				
			# * variable individual path fragment embedded in path fragment, individual or multiple ( '%individual_variable_fragment%' )
			elsif variable_path_fragment?( this_part )

				variable_name = this_part.slice( 1, this_part.length - 1 )
				regularized_path_parts.push( Rmagnets::ViewPath::PathPart::Variable.new( variable_name ) )

			elsif regexp_path_fragment?( this_part )

				regexp = this_part.slice( 1, this_part.length - 1 )
				regularized_path_parts.push( Regexp.new( regexp ).extend( Rmagnets::ViewPath::PathPart::RegularExpression ) )

			elsif anypath_path_fragment?( this_part )

				# two possibilities:
				# * pathpart*
				# * pathpart/* => *
				
				anypath_parts = this_part.split( '*' )
				
				unless anypath_parts.empty?
					regularized_path_parts.push( anypath_parts[ 0 ].extend( Rmagnets::ViewPath::PathPart::Constant ) )
				end

				regularized_path_parts.push( '*'.extend( Rmagnets::ViewPath::PathPart::AnyParts ) )

			# * individual path fragment ( path )
			else

				# string
				regularized_path_parts.push( this_part.extend( Rmagnets::ViewPath::PathPart::Constant ) )

			end

		end

		return regularized_path_parts
		
	end

  #############################
  #  variable_path_fragment?  #
  #############################

	def variable_path_fragment?( path_fragment )
		return path_fragment[ 0 ] == VariableDelimiter && path_fragment[ path_fragment.length - 1 ] == VariableDelimiter
	end

  ###########################
  #  regexp_path_fragment?  #
  ###########################

	def regexp_path_fragment?( path_fragment )
		return path_fragment[ 0 ] == RegexpDelimiter && path_fragment[ path_fragment.length - 1 ] == RegexpDelimiter
	end

  ############################
  #  anypath_path_fragment?  #
  ############################

	def anypath_path_fragment?( path_fragment )
		return path_fragment[ path_fragment.length - 1 ] == AnyPathDelimiter
	end
	
end
