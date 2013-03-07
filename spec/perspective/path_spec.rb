# -*- encoding : utf-8 -*-

require_relative '../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path do

  ################
  #  initialize  #
  ################

  it 'will initialize with or without path parts' do
    
    path_instance = ::Perspective::Request::Path.new
    path_instance.parts.is_a?( ::Array )
    path_instance.parts.count.should == 0

    path_instance_two = ::Perspective::Request::Path.new( 'constant' )
    path_instance_two.parts.is_a?( ::Array )
    path_instance_two.parts.count.should == 1
    path_instance_two.parts[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    
  end
  
  ########
  #  []  #
  ########

  it 'will address the parts array directly' do

    path_instance = ::Perspective::Request::Path.new( 'constant' )
    path_instance.parts.is_a?( ::Array )
    path_instance.parts.count.should == 1
    path_instance[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    
  end
  
  ########################
  #  match_request_path  #
  ########################
  
  it 'will match for all declared parts' do
    
    path = ::Perspective::Request::Path.new( '' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '', path )
    request_path.match.should == true
    
    # Constant
    # - followed by Constant
    path = ::Perspective::Request::Path.new( 'some/request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Perspective::Request::Path.new( 'some', :request )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Perspective::Request::Path.new( 'some', /request/ )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Perspective::Request::Path.new( 'some', [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Perspective::Request::Path.new( 'some', :request => 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Variable
    # - followed by Constant
    path = ::Perspective::Request::Path.new( :some, 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Perspective::Request::Path.new( :some, :request )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Perspective::Request::Path.new( :some, /request/ )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Perspective::Request::Path.new( :some, [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Perspective::Request::Path.new( :some, :request => 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Regexp
    # - followed by Constant
    path = ::Perspective::Request::Path.new( /some/, 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Perspective::Request::Path.new( /some/, :request )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Perspective::Request::Path.new( /some/, /request/ )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Perspective::Request::Path.new( /some/, [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Perspective::Request::Path.new( /some/, :request => 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Optional
    # - followed by Constant
    path = ::Perspective::Request::Path.new( [ 'some' ], 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Perspective::Request::Path.new( [ 'some' ], :request )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Perspective::Request::Path.new( [ 'some' ], /request/ )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Perspective::Request::Path.new( [ 'some' ], [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    path = ::Perspective::Request::Path.new( [ 'some' ], [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/no/match', path )
    request_path.match.should == false
    path = ::Perspective::Request::Path.new( [ 'some' ], [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/none', path )
    request_path.match.should == false
    # - followed by Named Optional
    path = ::Perspective::Request::Path.new( [ 'some' ], :request => 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Named Optional
    # - followed by Constant
    path = ::Perspective::Request::Path.new( { :some => 'some' }, 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Perspective::Request::Path.new( { :some => 'some' }, :request )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Perspective::Request::Path.new( { :some => 'some' }, /request/ )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Perspective::Request::Path.new( { :some => 'some' }, [ 'request' ] )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Perspective::Request::Path.new( { :some => 'some' }, :request => 'request' )
    request_path = ::Perspective::Request::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
  end
  
end
