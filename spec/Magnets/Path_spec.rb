
require_relative '../../lib/magnets-path.rb'

describe ::Magnets::Path do

  ################
  #  initialize  #
  ################

  it 'can initialize with or without path parts' do
    
    path_instance = ::Magnets::Path.new
    path_instance.parts.is_a?( Array )
    path_instance.parts.count.should == 0

    path_instance_two = ::Magnets::Path.new( 'constant' )
    path_instance_two.parts.is_a?( Array )
    path_instance_two.parts.count.should == 1
    path_instance_two.parts[ 0 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    
  end
  
  ########
  #  []  #
  ########

  it 'can address the parts array directly' do

    path_instance = ::Magnets::Path.new( 'constant' )
    path_instance.parts.is_a?( Array )
    path_instance.parts.count.should == 1
    path_instance[ 0 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    
  end
  
  ########################
  #  match_request_path  #
  ########################
  
  it 'can match for all declared parts' do
    
    path = ::Magnets::Path.new( '' )
    request_path = ::Magnets::Path::RequestPath.new( '', path )
    request_path.match.should == true
    
    # Constant
    # - followed by Constant
    path = ::Magnets::Path.new( 'some/request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Magnets::Path.new( 'some', :request )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Magnets::Path.new( 'some', /request/ )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Magnets::Path.new( 'some', [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Magnets::Path.new( 'some', :request => 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Variable
    # - followed by Constant
    path = ::Magnets::Path.new( :some, 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Magnets::Path.new( :some, :request )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Magnets::Path.new( :some, /request/ )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Magnets::Path.new( :some, [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Magnets::Path.new( :some, :request => 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Regexp
    # - followed by Constant
    path = ::Magnets::Path.new( /some/, 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Magnets::Path.new( /some/, :request )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Magnets::Path.new( /some/, /request/ )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Magnets::Path.new( /some/, [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Magnets::Path.new( /some/, :request => 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Optional
    # - followed by Constant
    path = ::Magnets::Path.new( [ 'some' ], 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Magnets::Path.new( [ 'some' ], :request )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Magnets::Path.new( [ 'some' ], /request/ )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Magnets::Path.new( [ 'some' ], [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    path = ::Magnets::Path.new( [ 'some' ], [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/no/match', path )
    request_path.match.should == false
    path = ::Magnets::Path.new( [ 'some' ], [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/none', path )
    request_path.match.should == false
    # - followed by Named Optional
    path = ::Magnets::Path.new( [ 'some' ], :request => 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
    # Named Optional
    # - followed by Constant
    path = ::Magnets::Path.new( { :some => 'some' }, 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Variable
    path = ::Magnets::Path.new( { :some => 'some' }, :request )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Regexp
    path = ::Magnets::Path.new( { :some => 'some' }, /request/ )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Optional
    path = ::Magnets::Path.new( { :some => 'some' }, [ 'request' ] )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    # - followed by Named Optional
    path = ::Magnets::Path.new( { :some => 'some' }, :request => 'request' )
    request_path = ::Magnets::Path::RequestPath.new( '/some/request', path )
    request_path.match.should == true
    
  end
  
end
