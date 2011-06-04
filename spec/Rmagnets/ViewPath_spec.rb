
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rmagnets View Path  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath do

	##########
  #  name  #
  ##########

  it 'requires a name be specified for later short-hand/programmatic access' do
    Rmagnets::ViewPath.new( :name ).name.should == :name
  end

	############
  #  scheme  #
  ############

  it 'can specify a scheme (ie. http, https); default is http' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      schemes.include?( 'http' )
      scheme( 'https' )
      schemes.include?( 'https' )
    end
  end

	############
  #  method  #
  ############

  it 'can specify one or more schemes (ie. GET/PUT/POST/DELETE); default is [ GET, PUT, POST, DELETE ]' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      methods.include?( :GET ).should == false
      methods.include?( :PUT ).should == false
      methods.include?( :POST ).should == false
      methods.include?( :DELETE ).should == false

      method( :GET )
      methods.include?( :GET ).should == true
      methods.should == [ :GET ]
      methods.delete( :GET )
      methods.include?( :GET ).should == false
      method( :get )
      methods.include?( :GET ).should == true
      methods.should == [ :GET ]

      method( :PUT )
      methods.include?( :PUT ).should == true
      methods.should == [ :GET, :PUT ]
      methods.delete( :PUT )
      methods.include?( :PUT ).should == false
      method( :put )
      methods.include?( :PUT ).should == true
      methods.should == [ :GET, :PUT ]

      method( :POST )
      methods.include?( :POST ).should == true
      methods.should == [ :GET, :PUT, :POST ]
      methods.delete( :POST )
      methods.include?( :POST ).should == false
      method( :post )
      methods.include?( :POST ).should == true
      methods.should == [ :GET, :PUT, :POST ]

      method( :DELETE )
      methods.include?( :DELETE ).should == true
      methods.should == [ :GET, :PUT, :POST, :DELETE ]
      methods.delete( :DELETE )
      methods.include?( :DELETE ).should == false
      method( :delete )
      methods.include?( :DELETE ).should == true
      methods.should == [ :GET, :PUT, :POST, :DELETE ]

      method( [ :GET, :PUT ] )
      methods.should == [ :GET, :PUT ]

      method( [ :POST, :PUT ] )
      methods.should == [ :POST, :PUT ]

    end
  end

	#########
  #  get  #
  #########

  it 'can specify GET' do
    Rmagnets::ViewPath.new( :name ).get.methods.should == [ :GET ]
  end

	#########
  #  put  #
  #########

  it 'can specify PUT' do
    Rmagnets::ViewPath.new( :name ).put.methods.should == [ :PUT ]
  end

	##########
  #  post  #
  ##########

  it 'can specify POST' do
    Rmagnets::ViewPath.new( :name ).post.methods.should == [ :POST ]
  end

	############
  #  delete  #
  ############

  it 'can specify DELETE' do
    Rmagnets::ViewPath.new( :name ).delete.methods.should == [ :DELETE ]
  end

	###################
  #  delete_method  #
  ###################

  it 'can remove a method that has previously been permitted' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      methods.should == []
      method( :PUT )
      methods.should == [ :PUT ]
      delete_method( :PUT )
      methods.should == []
      method( :PUT )
      methods.should == [ :PUT ]
      delete_method( :put )
      methods.should == []
    end
  end
  
	##############
  #  host      #
  #  hostname  #
  ##############

  it 'can specify a hostname; hostnames and IPs are additive, not exclusive; default matches any hostname' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      hosts.should == []
      host( 'somedomain.com' )
      hosts.should == [ 'somedomain.com' ]
      method( :host ).should == method( :hostname )
    end
  end

	########
  #  ip  #
  ########

  it 'can specify an IP address; IPs and hostnames are additive, not exclusive; default matches any IP' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      ips.should == []
      ip( '10.0.0.1' )
      ips.should == [ '10.0.0.1' ]
      method( :ip ).should == method( :address )
    end    
  end

	##########
  #  port  #
  ##########

  it 'can specify one or more ports; default matches any port' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      ports.should == []
      port( 80 )
      ports.should == [ 80 ]
    end    
  end

	#############
  #  referer  #
  #############

  it 'can specify a referer; default matches any referer' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      referers.should == []
      view_path = Rmagnets::ViewPath.new( :referer )
      referer( view_path )
      referers.should == [ view_path ]
    end
  end

	################
  #  user_agent  #
  ################

  it 'can specify a user-agent; default matches any user-agent' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      user_agents.should == []
      user_agent( 'some_agent' )
      user_agents.should == [ 'some_agent' ]
    end
  end

	##############
  #  basepath  #
  ##############

  it 'can declare an additional basepath for matching viewpath routes (no default basepath)' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      basepaths.is_a?( Array ).should == true
      basepaths.empty?.should == true
      basepath( 'root', :some_path )
      basepaths[ 0 ].is_a?( Array ).should == true
      basepaths[ 0 ][ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      basepaths[ 0 ][ 1 ].is_a?( Rmagnets::ViewPath::PathPart::Variable ).should == true
    end
  end
	
	##########
  #  path  #
  ##########

  it 'can declare an additional path (no default path)' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      paths.is_a?( Array ).should == true
      paths.empty?.should == true
      path( 'root', :some_path )
      paths[ 0 ].is_a?( Array ).should == true
      paths[ 0 ][ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      paths[ 0 ][ 1 ].is_a?( Rmagnets::ViewPath::PathPart::Variable ).should == true
    end
  end

	##########
  #  bind  #
  ##########

  it 'can declare a view to be rendered to a binding' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      render_stack.is_a?( Array ).should == true
      render_stack.empty?.should == true
      configuration_block = Proc.new do |viewpath, view|
        puts 'viewpath configuration space'
      end
      binding( :binding_name, Rmagnets::ViewPath, & configuration_block ) 
      render_stack[ 0 ].is_a?( Rmagnets::ViewPath::RenderStackBindingStruct ).should == true
      render_stack[ 0 ][ :name ].should == :binding_name
      render_stack[ 0 ][ :view_class ].should == Rmagnets::ViewPath
      render_stack[ 0 ][ :configuration_block_proc ].should == configuration_block
    end
  end
	
	##########
  #  view  #
  ##########

  it 'can declare a view to be rendered to the document stack' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      render_stack.is_a?( Array ).should == true
      render_stack.empty?.should == true
      configuration_block = Proc.new do |viewpath, view|
        puts 'viewpath configuration space'
      end
      view( Rmagnets::ViewPath, & configuration_block ) 
      render_stack[ 0 ].is_a?( Rmagnets::ViewPath::RenderStackViewStruct ).should == true
      render_stack[ 0 ][ :view_class ].should == Rmagnets::ViewPath
      render_stack[ 0 ][ :configuration_block_proc ].should == configuration_block
    end
  end

	##################
  #  match_scheme  #
  ##################

  it 'can match declared scheme vs. request scheme' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      match_scheme( 'http' ).should == true
      scheme( 'https' )
      match_scheme( 'https' ).should == true
      match_scheme( 'http' ).should == false
      scheme( 'http' )
      match_scheme( 'http' ).should == true
    end
  end
	
	##################
  #  match_method  #
  ##################

  it 'can match method scheme vs. request method' do
    Rmagnets::ViewPath.new( :name ).instance_eval do

      match_method( :GET ).should == true
      match_method( :PUT ).should == true
      match_method( :POST ).should == true
      match_method( :DELETE ).should == true

      method( :GET )
      match_method( :GET ).should == true
      match_method( :PUT ).should == false
      match_method( :POST ).should == false
      match_method( :DELETE ).should == false

      method( :PUT )
      match_method( :GET ).should == true
      match_method( :PUT ).should == true
      match_method( :POST ).should == false
      match_method( :DELETE ).should == false

      method( :POST )
      match_method( :GET ).should == true
      match_method( :PUT ).should == true
      match_method( :POST ).should == true
      match_method( :DELETE ).should == false

      method( :DELETE )
      match_method( :GET ).should == true
      match_method( :PUT ).should == true
      match_method( :POST ).should == true
      match_method( :DELETE ).should == true

    end    
  end

	################
  #  match_host  #
  ################

  it 'can match declared host vs. request host' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      match_host( 'anyhost.com' ).should == true
      host( 'somehost.com' )
      match_host( 'anyhost.com' ).should == false
      match_host( 'somehost.com' ).should == true
      host( 'anotherhost.com' )
      match_host( 'anotherhost.com' ).should == true
    end
  end

	##############
  #  match_ip  #
  ##############

  it 'can match declared IP vs. request IP' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      match_ip( '10.0.0.1' ).should == true
      ip( '10.0.0.2' )
      match_ip( '10.0.0.1' ).should == false
      match_ip( '10.0.0.2' ).should == true
      ip( '10.0.0.3' )
      match_ip( '10.0.0.3' ).should == true
    end
  end

	################
  #  match_port  #
  ################

  it 'can match declared port vs. request port' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      match_port( 80 ).should == true
      port( 81 )
      match_port( 80 ).should == false
      match_port( 81 ).should == true
      port( 80 )
      match_port( 80 ).should == true
    end
  end

	###################
  #  match_referer  #
  ###################

  it 'can match declared referer vs. request referer' do
    pending 'ensure format processing of referer'
    Rmagnets::ViewPath.new( :name ).instance_eval do
      match_referer( Rmagnets::ViewPath.new( :referer_path ) ).should == true
      referer( Rmagnets::ViewPath.new( :referer_path ).host( 'some_host.com' ).path( 'some_path' ) )
      match_referer( 'other_host.com/some_path' ).should == false
      match_referer( 'some_host.com/some_path' ).should == true
      referer( Rmagnets::ViewPath.new( :referer_path ).host( 'other_host.com' ).path( 'some_path' ) )
      match_referer( 'other_host.com/some_path' ).should == true
    end
  end

	######################
  #  match_user_agent  #
  ######################

  it 'can match declared user-agent vs. request user-agent' do
    pending 'not very important; write/ensure later'
  end
	
	#############################
  #  match_non_path_elements  #
  #############################

  it 'can match all of the non-path elements at once' do
    pending 'works implicitly, write test later'
  end

  ###########################
  #  match_path_descriptor  #
  ###########################

  it 'can match against a single declared path' do
    Rmagnets::ViewPath.new( :name ).instance_eval do

      # constant
      constant_part  = 'some_path'.extend( Rmagnets::ViewPath::PathPart::Constant )
      descriptors    = [ constant_part ]
      path_parts     = [ 'some_path' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'some_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil

      # multipath constant
      constant_part  = 'some_path'.extend( Rmagnets::ViewPath::PathPart::Constant )
      other_constant_part  = 'other_path'.extend( Rmagnets::ViewPath::PathPart::Constant )
      descriptors    = [ constant_part, other_constant_part ]
      path_parts     = [ 'some_path', 'other_path' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'some_path', 'other_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'other_path', 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil

      # variable
      variable_part  = Rmagnets::ViewPath::PathPart::Variable.new( :any_path )
      descriptors    = [ variable_part ]
      path_parts     = [ 'anything' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'anything' ]

      # regexp
      regexp_part  = Regexp.new( 'some_regexp(\d*)' ).extend( Rmagnets::ViewPath::PathPart::RegularExpression )
      descriptors    = [ regexp_part ]
      path_parts     = [ 'some_regexp12' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12' ]
      path_parts     = [ 'some_regexp37' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp37' ]
      path_parts     = [ 'some_regexp' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp' ]
      path_parts     = [ 'not_some_regexp' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil
      path_parts     = [ 'not_some_regexp13' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, variable, regexp
      descriptors    = [ constant_part, variable_part, regexp_part ]
      path_parts     = [ 'some_path', 'anything', 'some_regexp12' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'anything', 'some_regexp12' ]
      non_matching_path   = [ 'some_path', 'anything', 'some_regexp12', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, regexp, variable
      descriptors    = [ constant_part, regexp_part, variable_part ]
      path_parts     = [ 'some_path', 'some_regexp12', 'anything' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'some_regexp12', 'anything' ]
      non_matching_path   = [ 'some_path', 'some_regexp12', 'anything', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil
      
      # variable, constant, regexp
      descriptors    = [ variable_part, constant_part, regexp_part ]
      path_parts     = [ 'anything', 'some_path', 'some_regexp12' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_path', 'some_regexp12' ]
      non_matching_path   = [ 'anything', 'some_path', 'some_regexp12', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # variable, regexp, constant
      descriptors    = [ variable_part, regexp_part, constant_part ]
      path_parts     = [ 'anything', 'some_regexp12', 'some_path' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_regexp12', 'some_path' ]
      non_matching_path   = [ 'anything', 'some_regexp12', 'some_path', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil
      
      # regexp, constant, variable
      descriptors    = [ regexp_part, constant_part, variable_part ]
      path_parts     = [ 'some_regexp12', 'some_path', 'anything' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'some_path', 'anything' ]
      non_matching_path   = [ 'some_regexp12', 'some_path', 'anything', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # regexp, variable, constant
      descriptors    = [ regexp_part, variable_part, constant_part ]
      path_parts     = [ 'some_regexp12', 'anything', 'some_path' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'anything', 'some_path' ]
      non_matching_path   = [ 'some_regexp12', 'anything', 'some_path', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

    end
  end
	
  #################
  #  match_paths  #
  #################

  it 'can match the request path against all declared paths' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # constant
      path( 'some_path' )
      match_paths( 'some_path' ).should == [ 'some_path' ]
      match_paths( 'some_path/other_path' ).should == nil
      match_paths( 'other_path' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # multipath constant
      path( 'some_path/other_path' )
      match_paths( 'some_path/other_path' ).should == [ 'some_path', 'other_path' ]
      match_paths( 'some_path/other_path/another_path' ).should == nil
      match_paths( 'some_path' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # variable
      path( :random_path )
      match_paths( 'anything' ).should == [ 'anything' ]
      match_paths( 'anything/another_path' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # regexp
      path( /some_regexp(\d*)/ )
      match_paths( 'some_regexp42' ).should == [ 'some_regexp42' ]
      match_paths( 'some_regexp42/other_path' ).should == nil
      match_paths( 'other_path' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # constant, variable, regexp
      path( 'some_path', :random_path, /some_regexp(\d*)/ )
      match_paths( 'some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_paths( 'some_path/other_path/not_regexp' ).should == nil
      match_paths( 'other_path/not_regexp' ).should == nil
      match_paths( 'other_path/not_regexp/some_regexp' ).should == nil
      match_paths( 'other_path/not_regexp/something_else' ).should == nil
      match_paths( 'some_path' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # constant, regexp, variable
      path( 'some_path', /some_regexp(\d*)/, :random_path )
      match_paths( 'some_path/some_regexp42/anything' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_paths( 'some_path/some_regexp42/anything/something_else' ).should == nil
      match_paths( 'some_path/some_regexp42' ).should == nil
      match_paths( 'some_path' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # variable, constant, regexp
      path( :random_path, 'some_path', /some_regexp(\d*)/ )
      match_paths( 'anything/some_path/some_regexp42' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_paths( 'anything/some_path/some_regexp42/something_else' ).should == nil
      match_paths( 'anything/some_path/something_else' ).should == nil
      match_paths( 'anything/something_else' ).should == nil
      match_paths( 'anything/some_path' ).should == nil
      match_paths( 'anything' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # variable, regexp, constant
      path( :random_path, /some_regexp(\d*)/, 'some_path' )
      match_paths( 'anything/some_regexp42/some_path' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_paths( 'anything/some_regexp42/some_path/something_else' ).should == nil
      match_paths( 'anything/some_regexp42' ).should == nil
      match_paths( 'anything/some_path' ).should == nil
      match_paths( 'anything/something_else' ).should == nil
      match_paths( 'anything' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # regexp, constant, variable
      path( /some_regexp(\d*)/, 'some_path', :random_path )
      match_paths( 'some_regexp42/some_path/anything' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_paths( 'some_regexp42/some_path/anything/something_else' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( 'some_path/anything' ).should == nil
      match_paths( 'something_else/anything' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # regexp, variable, constant
      path( /some_regexp(\d*)/, :random_path, 'some_path' )
      match_paths( 'some_regexp42/anything/some_path' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_paths( 'some_regexp42/anything/some_path/something_else' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( 'some_path/anything' ).should == nil
      match_paths( 'something_else/anything' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( '' ).should == nil
    end
  end
	
	###############################
  #  match_basepath_descriptor  #
  ###############################

  it 'can match against a single declared basepath' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
    
      # constant
      constant_part  = 'some_path'.extend( Rmagnets::ViewPath::PathPart::Constant )
      descriptors    = [ constant_part ]
      path_parts     = [ 'some_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors, path_parts ).should == [ 'some_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil

      # multipath constant
      constant_part  = 'some_path'.extend( Rmagnets::ViewPath::PathPart::Constant )
      other_constant_part  = 'other_path'.extend( Rmagnets::ViewPath::PathPart::Constant )
      descriptors    = [ constant_part, other_constant_part ]
      path_parts     = [ 'some_path', 'other_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors, path_parts ).should == [ 'some_path', 'other_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'other_path', 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil

      # variable
      variable_part  = Rmagnets::ViewPath::PathPart::Variable.new( :any_path )
      descriptors    = [ variable_part ]
      path_parts     = [ 'anything' ]
      match_basepath_descriptor( descriptors, path_parts ).should == [ 'anything' ]

      # regexp
      regexp_part  = Regexp.new( 'some_regexp(\d*)' ).extend( Rmagnets::ViewPath::PathPart::RegularExpression )
      descriptors    = [ regexp_part ]
      path_parts     = [ 'some_regexp12', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12' ]
      path_parts     = [ 'some_regexp37' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp37' ]
      path_parts     = [ 'some_regexp' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp' ]
      path_parts     = [ 'not_some_regexp' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
      path_parts     = [ 'not_some_regexp13' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, variable, regexp
      descriptors    = [ constant_part, variable_part, regexp_part ]
      path_parts     = [ 'some_path', 'anything', 'some_regexp12', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'anything', 'some_regexp12' ]
      non_matching_path   = [ 'some_path', 'anything', 'some_regexp12', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, regexp, variable
      descriptors    = [ constant_part, regexp_part, variable_part ]
      path_parts     = [ 'some_path', 'some_regexp12', 'anything', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'some_regexp12', 'anything' ]
      non_matching_path   = [ 'some_path', 'some_regexp12', 'anything', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
    
      # variable, constant, regexp
      descriptors    = [ variable_part, constant_part, regexp_part ]
      path_parts     = [ 'anything', 'some_path', 'some_regexp12', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_path', 'some_regexp12' ]
      non_matching_path   = [ 'anything', 'some_path', 'some_regexp12', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # variable, regexp, constant
      descriptors    = [ variable_part, regexp_part, constant_part ]
      path_parts     = [ 'anything', 'some_regexp12', 'some_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_regexp12', 'some_path' ]
      non_matching_path   = [ 'anything', 'some_regexp12', 'some_path', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
    
      # regexp, constant, variable
      descriptors    = [ regexp_part, constant_part, variable_part ]
      path_parts     = [ 'some_regexp12', 'some_path', 'anything', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'some_path', 'anything' ]
      non_matching_path   = [ 'some_regexp12', 'some_path', 'anything', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # regexp, variable, constant
      descriptors    = [ regexp_part, variable_part, constant_part ]
      path_parts     = [ 'some_regexp12', 'anything', 'some_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'anything', 'some_path' ]
      non_matching_path   = [ 'some_regexp12', 'anything', 'some_path', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
    
    end
    
  end
  
  #####################
  #  match_basepaths  #
  #####################

  it 'can match the request path against all declared base paths' do
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # constant
      basepath( 'some_path' )
      match_basepaths( 'some_path/some_other_part/something_else' ).should == [ 'some_path' ]
      match_basepaths( 'some_path/other_path' ).should == [ 'some_path' ]
      match_basepaths( 'other_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # multipath constant
      basepath( 'some_path/other_path' )
      match_basepaths( 'some_path/other_path/some_other_part/something_else' ).should == [ 'some_path', 'other_path' ]
      match_basepaths( 'some_path/another_path' ).should == nil
      match_basepaths( 'some_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # variable
      basepath( :random_path )
      match_basepaths( 'anything/some_other_part/something_else' ).should == [ 'anything' ]
      match_basepaths( 'anything/something_else' ).should == [ 'anything' ]
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # regexp
      basepath( /some_regexp(\d*)/ )
      match_basepaths( 'some_regexp42/some_other_part/something_else' ).should == [ 'some_regexp42' ]
      match_basepaths( 'some_regexp42/other_path' ).should == [ 'some_regexp42' ]
      match_basepaths( 'other_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # constant, variable, regexp
      basepath( 'some_path', :random_path, /some_regexp(\d*)/ )
      match_basepaths( 'some_path/anything/some_regexp42/some_other_part/something_else' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_basepaths( 'some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_basepaths( 'other_path/not_regexp' ).should == nil
      match_basepaths( 'other_path/not_regexp/some_regexp' ).should == nil
      match_basepaths( 'other_path/not_regexp/something_else' ).should == nil
      match_basepaths( 'some_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # constant, regexp, variable
      basepath( 'some_path', /some_regexp(\d*)/, :random_path )
      match_basepaths( 'some_path/some_regexp42/anything/some_other_part/something_else' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_basepaths( 'some_path/some_regexp42/anything/something_else' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_basepaths( 'some_path/some_regexp42' ).should == nil
      match_basepaths( 'some_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # variable, constant, regexp
      basepath( :random_path, 'some_path', /some_regexp(\d*)/ )
      match_basepaths( 'anything/some_path/some_regexp42/some_other_part/something_else' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_basepaths( 'anything/some_path/some_regexp42/something_else' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_basepaths( 'anything/some_path/something_else' ).should == nil
      match_basepaths( 'anything/something_else' ).should == nil
      match_basepaths( 'anything/some_path' ).should == nil
      match_basepaths( 'anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # variable, regexp, constant
      basepath( :random_path, /some_regexp(\d*)/, 'some_path' )
      match_basepaths( 'anything/some_regexp42/some_path/some_other_part/something_else' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_basepaths( 'anything/some_regexp42/some_path/something_else' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_basepaths( 'anything/some_regexp42' ).should == nil
      match_basepaths( 'anything/some_path' ).should == nil
      match_basepaths( 'anything/something_else' ).should == nil
      match_basepaths( 'anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # regexp, constant, variable
      basepath( /some_regexp(\d*)/, 'some_path', :random_path )
      match_basepaths( 'some_regexp42/some_path/anything/some_other_part/something_else' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_basepaths( 'some_regexp42/some_path/anything/something_else' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( 'some_path/anything' ).should == nil
      match_basepaths( 'something_else/anything' ).should == nil
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
    Rmagnets::ViewPath.new( :name ).instance_eval do
      # regexp, variable, constant
      basepath( /some_regexp(\d*)/, :random_path, 'some_path' )
      match_basepaths( 'some_regexp42/anything/some_path/some_other_part/something_else' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_basepaths( 'some_regexp42/anything/some_path/something_else' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( 'some_path/anything' ).should == nil
      match_basepaths( 'something_else/anything' ).should == nil
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
  end

end
