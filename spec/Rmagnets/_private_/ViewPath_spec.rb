
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rmagnets View Path  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../lib/rmagnets-view-path.rb'

describe Rmagnets::ViewPath do

	#############################
  #  path_fragments_for_path  #
  #############################

  it 'can return path fragments for a path given in string form' do
    Rmagnets::ViewPath.new( :some_view_path ).instance_eval do
      path_string = 'some/path/to/somewhere'
      result_array = [ 'some', 'path', 'to', 'somewhere' ]
      path_fragments_for_path( path_string ).should == result_array
      path_fragments_for_path( '/' + path_string ).should == result_array
      path_fragments_for_path( '/' + path_string + '/' ).should == result_array
    end
  end

  #########################
  #  parse_path_fragment  #
  #########################

  it 'can regularize an array of path fragments and return corresponding PathPart objects' do
    Rmagnets::ViewPath.new( :some_view_path ).instance_eval do
      results = parse_path_fragment( 'some/path' )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 1 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results = parse_path_fragment( '/some/fragment' )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 1 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results = parse_path_fragment( 'another/fragment/' )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 1 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results = parse_path_fragment( '%variable%' )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Variable ).should == true
      results = parse_path_fragment( '#regexp#' )
      results[ 0 ].is_a?( Regexp ).should == true
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::RegularExpression ).should == true
      results = parse_path_fragment( 'final_static_part*' )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 0 ] == 'final_static_part'
      results[ 1 ].is_a?( Rmagnets::ViewPath::PathPart::AnyParts ).should == true
      results = parse_path_fragment( '*' )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::AnyParts ).should == true
    end
  end

	############################
  #  regularized_path_parts  #
  ############################

  it 'can regularize path fragments for later consistency in matching' do
    Rmagnets::ViewPath.new( :some_view_path ).instance_eval do
      results = regularized_path_parts( [ :variable, 'some/path', /other_path/, [ :optional_part ], { :named_part => :named_optional_part }, 'final_static_part*' ] )
      results[ 0 ].is_a?( Rmagnets::ViewPath::PathPart::Variable ).should == true
      results[ 1 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 2 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 3 ].is_a?( Rmagnets::ViewPath::PathPart::RegularExpression ).should == true
      results[ 4 ].is_a?( Rmagnets::ViewPath::PathPart::OptionalPart ).should == true
      results[ 5 ].is_a?( Rmagnets::ViewPath::PathPart::OptionalPart::Named ).should == true
      results[ 6 ].is_a?( Rmagnets::ViewPath::PathPart::Constant ).should == true
      results[ 7 ].is_a?( Rmagnets::ViewPath::PathPart::AnyParts ).should == true
    end
  end
  
  #############################
  #  variable_path_fragment?  #
  #############################

  it 'can treat a string fragment with %variable% as a variable path fragment' do
    Rmagnets::ViewPath.new( :some_view_path ).instance_eval do
      variable_path_fragment?( '%variable%' ).should == true
      variable_path_fragment?( '#regexp#' ).should == false
      variable_path_fragment?( 'part*' ).should == false
      variable_path_fragment?( '*' ).should == false
    end
  end
  
  ###########################
  #  regexp_path_fragment?  #
  ###########################

  it 'can treat a string fragment with #regexp# as a regular expression path fragment' do
    Rmagnets::ViewPath.new( :some_view_path ).instance_eval do
      regexp_path_fragment?( '#regexp#' ).should == true    
      regexp_path_fragment?( '%variable%' ).should == false
      variable_path_fragment?( 'part*' ).should == false
      variable_path_fragment?( '*' ).should == false
    end
  end

  ############################
  #  anypath_path_fragment?  #
  ############################

  it 'can treat a string fragment with #regexp# as a regular expression path fragment' do
    Rmagnets::ViewPath.new( :some_view_path ).instance_eval do
      anypath_path_fragment?( '#regexp#' ).should == false    
      anypath_path_fragment?( '%variable%' ).should == false
      anypath_path_fragment?( 'part*' ).should == true
      anypath_path_fragment?( '*' ).should == true
    end
  end

end
