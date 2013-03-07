# -*- encoding : utf-8 -*-

require_relative '../../../lib/perspective/request/path.rb'

describe ::Perspective::Request::Path::Parser do

  ###################################
  #  self.regularize_path_or_parts  #
  ###################################

  it 'will regularize paths and parts' do
    
    paths = ::Perspective::Request::Path::Parser.regularize_path_or_parts( :variable, 'some/path', /parts/, ::Perspective::Request::Path.new( 'some/path' ), 'some/other', 'path', ''  )
    paths.count.should == 4
    paths[ 0 ].count.should == 4
    paths[ 0 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Variable ).should == true
    paths[ 0 ][ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 0 ][ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 0 ][ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Regexp ).should == true
    paths[ 1 ].count.should == 2
    paths[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 1 ][ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 2 ].count.should == 3
    paths[ 2 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 2 ][ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 2 ][ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    paths[ 3 ].count.should == 1
    paths[ 3 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Empty ).should == true
    
    ::Perspective::Request::Path::Parser.regularize_path_or_parts( *paths ).should == paths
    
  end

  #################################
  #  self.parse_path_part_string  #
  #################################

  it 'will take a descriptor string for a single path and parse it into corresponding fragment objects' do
    
    ::Perspective::Request::Path::Parser.parse_path_part_string( '' ).is_a?( ::Perspective::Request::Path::PathPart::Empty ).should == true
    ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#' ).is_a?( ::Perspective::Request::Path::PathPart::Regexp ).should == true
    ::Perspective::Request::Path::Parser.parse_path_part_string( '%variable%' ).is_a?( ::Perspective::Request::Path::PathPart::Variable ).should == true
    ::Perspective::Request::Path::Parser.parse_path_part_string( 'constant' ).is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#%variable%constant' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '%variable%#regexp#constant' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( 'constant#regexp#%variable%' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#%variable%%variable%constant#regexp#*#regexp#constant#regexp#' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 5 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 6 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 7 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 8 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#%variable%%variable%*constant#regexp##regexp#constant#regexp#' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 5 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 6 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 7 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 8 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#%variable%**%variable%constant#regexp#*#regexp#constant#regexp#' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::MultipathVariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 5 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 6 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 7 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 8 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 9 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    
    multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#%variable%%variable%*constant#regexp##regexp#**constant#regexp#' )
    multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 5 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 6 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 7 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::MultipathVariableFragment ).should == true
    multiple[ 8 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 9 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true

    optional = ::Perspective::Request::Path::Parser.parse_path_part_string( '|#regexp#%variable%%variable%*constant#regexp##regexp#**constant#regexp#|' )
    optional.is_a?( ::Perspective::Request::Path::PathPart::Optional ).should == true
    optional[0].is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    optional[0][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    optional[0][ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    optional[0][ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    optional[0][ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    optional[0][ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    optional[0][ 5 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    optional[0][ 6 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    optional[0][ 7 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::MultipathVariableFragment ).should == true
    optional[0][ 8 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    optional[0][ 9 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true

    #multiple = ::Perspective::Request::Path::Parser.parse_path_part_string( '#regexp#|%variable%%variable%*constant#regexp##regexp#|**constant#regexp#' )
    #multiple.is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    #multiple[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    #multiple[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::OptionalFragment )
    #multiple[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    #multiple[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    #multiple[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    #multiple[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    #multiple[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    #multiple[ 1 ][ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    #multiple[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::MultipathVariableFragment ).should == true
    #multiple[ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    #multiple[ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true

  end

  #######################################
  #  self.parse_string_for_descriptors  #
  #######################################

  it 'will take a descriptor string and parse it into corresponding objects' do

    ::Perspective::Request::Path::Parser.parse_string_for_descriptors( '#regexp#' )[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Regexp ).should == true
    ::Perspective::Request::Path::Parser.parse_string_for_descriptors( '%variable%' )[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Variable ).should == true
    ::Perspective::Request::Path::Parser.parse_string_for_descriptors( 'constant' )[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    
    path_parts = ::Perspective::Request::Path::Parser.parse_string_for_descriptors( 'some/path/part/#regexp#/#regexp#const%variable_name%/constant/%variable_name%**constant/endpath' )
    path_parts.count.should == 8
    path_parts[ 0 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    path_parts[ 1 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    path_parts[ 2 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    path_parts[ 3 ].is_a?( ::Perspective::Request::Path::PathPart::Regexp ).should == true
    path_parts[ 4 ].is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    path_parts[ 4 ][0].is_a?( ::Perspective::Request::Path::PathPart::Fragment::RegexpFragment ).should == true
    path_parts[ 4 ][1].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    path_parts[ 4 ][2].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    path_parts[ 5 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    path_parts[ 6 ].is_a?( ::Perspective::Request::Path::PathPart::Multiple ).should == true
    path_parts[ 6 ][0].is_a?( ::Perspective::Request::Path::PathPart::Fragment::VariableFragment ).should == true
    path_parts[ 6 ][1].is_a?( ::Perspective::Request::Path::PathPart::Fragment::MultipathVariableFragment ).should == true
    path_parts[ 6 ][2].is_a?( ::Perspective::Request::Path::PathPart::Fragment::ConstantFragment ).should == true
    path_parts[ 7 ].is_a?( ::Perspective::Request::Path::PathPart::Constant ).should == true
    
  end
  
end
