
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
  
end
