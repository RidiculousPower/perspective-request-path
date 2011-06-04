
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rmagnets View Path  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rmagnets::ViewPath

	attr_accessor	:name
	attr_writer		:scheme, :method, :host, :ip, :port, :referer, :user_agent
	attr_reader		:schemes, :methods, :hosts, :ips, :ports, :referers, :user_agents, 
								:paths, :basepaths, :configuration_block_proc, :render_stack

	VariableDelimiter		= '%'
	RegexpDelimiter			= '#'

	RenderStackBindingStruct = Struct.new( :name, :view_class, :configuration_block_proc )
	RenderStackViewStruct    = Struct.new( :view_class, :configuration_block_proc )

	################
  #  initialize  #
  ################

  def initialize( name = nil )

		@name 										= name

		@schemes 									= Array.new
		@methods 									= Array.new
		@hosts 										= Array.new
		@ips 											= Array.new
		@ports 										= Array.new
		@referers 								= Array.new
		@user_agents 							= Array.new

		@paths 										= Array.new
		@basepaths 								= Array.new

		@matched_path_variables		= Array.new
		@render_stack							= Array.new
		
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

	############
  #  method  #
  ############

  def method( *methods )
		
		if methods[ 0 ].is_a?( Array )
			@methods = methods[ 0 ]
		else
			@methods.concat( methods.collect { |this_method| this_method.to_s.upcase.to_sym } ).uniq!
		end
		
		return self
		
  end

	#########
  #  get  #
  #########

  def get
	
		method( :GET )
		
		return self
		
  end

	#########
  #  put  #
  #########

  def put
	
		method( :PUT )
		
		return self
		
  end

	##########
  #  post  #
  ##########

  def post
	
		method( :POST )
		
		return self
		
  end

	############
  #  delete  #
  ############

  def delete
	
		method( :DELETE )
		
		return self
		
  end

	###################
  #  delete_method  #
  ###################

	def delete_method( *methods )
		
		@methods -= methods.collect { |this_method| this_method.to_s.upcase.to_sym }
		
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

		@paths = Array.new
		
		return self

	end
	
	#################
  #  delete_path  #
  #################

  def delete_path( index )
		
		@paths.delete_at( index )
		
		return self
		
	end
	
	##########
  #  bind  #
  ##########

  def binding( binding_name, view_class, & configuration_block_proc )

		@render_stack.push( RenderStackBindingStruct.new( binding_name, view_class, configuration_block_proc ) )
		
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

  def view( view_class, & configuration_block_proc )

		@render_stack.push( RenderStackViewStruct.new( view_class, configuration_block_proc ) )
		
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
				match_method( request.method )					and
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

	def match_method( request_method )

		matched_method = false
		
		if @methods.empty? or @methods.include?( request_method )
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

		matched_path_parts = match_basepath_descriptor( descriptor_elements, path_parts )
		
		matched_path_parts = nil if descriptor_elements.empty? and ! path_parts.empty?
		
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
		
		matched_path_parts = Array.new

		failed = false

		# this viewpath can have multiple paths that match; first one works
		while this_descriptor = descriptor_elements.shift
			if path_parts.empty? or ! this_descriptor.match_request( descriptor_elements, path_parts )
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

end
