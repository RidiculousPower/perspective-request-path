
require_relative '../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart do

  ##################################################################################################
  #  private #######################################################################################
  ##################################################################################################
  

	###########################################
  #  parse_and_regularize_path_descriptors  #
  ###########################################

  it 'can regularize path fragments for later consistency in matching' do
    ::Magnets::Path.new( :some_view_path ).instance_eval do
      results = parse_and_regularize_path_descriptors( [ :variable, 'some/path', /other_path/, [ :optional_part ], { :named_part => :named_optional_part }, 'final_static_part*' ] )
      results[ 0 ].is_a?( ::Magnets::Path::PathPart::Variable ).should == true
      results[ 1 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
      results[ 2 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
      results[ 3 ].is_a?( ::Magnets::Path::PathPart::Regexp ).should == true
      results[ 4 ].is_a?( ::Magnets::Path::PathPart::Optional ).should == true
      results[ 5 ].is_a?( ::Magnets::Path::PathPart::Optional::NamedOptional ).should == true
      results[ 6 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
      results[ 7 ].is_a?( ::Magnets::Path::PathPart::Wildcard ).should == true
    end
  end
  

end
