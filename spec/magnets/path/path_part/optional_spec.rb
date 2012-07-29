
require_relative '../../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart::Optional do

	########################################
	#  initialize                          #
	#  initialize_sub_option_combinations  #
	########################################

	it 'can initialize with nested parts' do
	  
	  optional_part = ::Magnets::Path::PathPart::Optional.new( 'some', 'path', 'to', 'constant' )

	  optional_part.configurations.count.should == 1
	  optional_part.configurations[ 0 ].count.should == 4
	  optional_part.configurations[ 0 ].sub_options.should == nil

	  optional_sub_part = ::Magnets::Path::PathPart::Optional.new( 'other' )
	  optional_part = ::Magnets::Path::PathPart::Optional.new( 'path', 'to', optional_sub_part )

	  optional_part.configurations.count.should == 2
	  optional_part.configurations[ 0 ].count.should == 3
	  optional_part.configurations[ 0 ].sub_options.should == { optional_sub_part => 0 } 
	  optional_part.configurations[ 1 ].count.should == 2
	  optional_part.configurations[ 1 ].sub_options.should == nil
	  
	  optional_sub_one_sub_part = ::Magnets::Path::PathPart::Optional.new( 'path', 'to' )
	  optional_sub_part_one = ::Magnets::Path::PathPart::Optional.new( 'other', optional_sub_one_sub_part )
	  optional_sub_two_sub_part = ::Magnets::Path::PathPart::Optional.new( 'or', 'two' )
	  optional_sub_part_two = ::Magnets::Path::PathPart::Optional.new( 'and', 'option', optional_sub_two_sub_part )
	  optional_part = ::Magnets::Path::PathPart::Optional.new( 'some', optional_sub_part_one, 'constant', optional_sub_part_two )
	  
	  optional_part.configurations.count.should == 10

	  optional_part.configurations[ 0 ].count.should == 9
	  optional_part.configurations[ 0 ].sub_options.should == { optional_sub_part_one => 0, optional_sub_part_two => 0 }
	  optional_part.configurations[ 1 ].count.should == 7
	  optional_part.configurations[ 1 ].sub_options.should == { optional_sub_part_one => 1, optional_sub_part_two => 0 }
	  optional_part.configurations[ 2 ].count.should == 7
	  optional_part.configurations[ 2 ].sub_options.should == { optional_sub_part_one => 0, optional_sub_part_two => 1 }
	  optional_part.configurations[ 3 ].count.should == 6
	  optional_part.configurations[ 3 ].sub_options.should == { optional_sub_part_two => 0 }
	  optional_part.configurations[ 4 ].count.should == 5
	  optional_part.configurations[ 4 ].sub_options.should == { optional_sub_part_one => 1, optional_sub_part_two => 1 }
	  optional_part.configurations[ 5 ].count.should == 5
	  optional_part.configurations[ 5 ].sub_options.should == { optional_sub_part_one => 0 }
	  optional_part.configurations[ 6 ].count.should == 4
	  optional_part.configurations[ 6 ].sub_options.should == { optional_sub_part_two => 1 }
	  optional_part.configurations[ 7 ].count.should == 3
	  optional_part.configurations[ 7 ].sub_options.should == { optional_sub_part_one => 1 }
	  optional_part.configurations[ 8 ].count.should == 2
	  optional_part.configurations[ 8 ].sub_options.should == { }
	  
  end

	###########
	#  match  #
	###########
  
  it 'can match an optional path portion' do
    
    optional_sub_one_sub_part = ::Magnets::Path::PathPart::Optional.new( 'path', 'to' )
	  optional_sub_part_one = ::Magnets::Path::PathPart::Optional.new( 'other', optional_sub_one_sub_part )
	  optional_sub_two_sub_part = ::Magnets::Path::PathPart::Optional.new( 'or', 'two' )
	  optional_sub_part_two = ::Magnets::Path::PathPart::Optional.new( 'and', 'option', optional_sub_two_sub_part )
	  optional_part = ::Magnets::Path::PathPart::Optional.new( 'some', optional_sub_part_one, 'constant', optional_sub_part_two )
	  path = ::Magnets::Path.new( optional_part )
	  
	  #request_path = ::Magnets::Path::RequestPath.new( '/some/constant/', path )
	  #optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/bad/constant/', path )
	  optional_part.match( request_path ).should == false

	  request_path = ::Magnets::Path::RequestPath.new( '/some/constant/bad/path', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'bad'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/constant/', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/other/constant/', path )
	  optional_part.match( request_path ).should == false
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/path/to/constant/', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/path/to/some/other/constant/', path )
	  optional_part.match( request_path ).should == false
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/constant/and/option', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/constant/and/option/2', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == '2'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/constant/and/option', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/constant/and/optional/path', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'and'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/path/to/constant/and/option', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/path/to/constant/and/then/an/option', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'and'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/constant/and/option/or/two', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/constant/and/option/or/two/three', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'three'
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/constant/and/option/or/two', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/constant/and/option/or/one/or/two', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'or'
	  
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/path/to/constant/and/option/or/two', path )
	  optional_part.match( request_path ).should == true
    
	  request_path = ::Magnets::Path::RequestPath.new( '/some/other/path/to/constant/and/an/option/or/two', path )
	  optional_part.match( request_path ).should == true
	  request_path.current_part.should == 'and'

  end
  
end
