
require_relative '../../../lib/magnets-path.rb'

describe ::Magnets::Path::PathPart do

  #################################################
  #  self.parse_path_part_string_for_descriptors  #
  #################################################

  it 'can take a descriptor string for a single path and parse it into corresponding fragment objects' do
    
    ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '#regexp#' ).is_a?( ::Magnets::Path::PathPart::Regexp ).should == true
    ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '%variable%' ).is_a?( ::Magnets::Path::PathPart::Variable ).should == true
    ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( 'constant' ).is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    
    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '#regexp#%variable%constant' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    
    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '%variable%#regexp#constant' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    
    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( 'constant#regexp#%variable%' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    
    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '#regexp#%variable%%variable%constant#regexp#*#regexp#constant#regexp#' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 4 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 5 ].is_a?( ::Magnets::Path::PathPart::Fragment::WildcardFragment ).should == true
    multiple[ 6 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 7 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 8 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true

    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '#regexp#%variable%%variable%*constant#regexp##regexp#constant#regexp#' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Magnets::Path::PathPart::Fragment::WildcardFragment ).should == true
    multiple[ 4 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 5 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 6 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 7 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 8 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    
    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '#regexp#%variable%**%variable%constant#regexp#*#regexp#constant#regexp#' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::MultipathWildcardFragment ).should == true
    multiple[ 3 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 4 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 5 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 6 ].is_a?( ::Magnets::Path::PathPart::Fragment::WildcardFragment ).should == true
    multiple[ 7 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 8 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 9 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true

    multiple = ::Magnets::Path::PathPart.parse_path_part_string_for_descriptors( '#regexp#%variable%%variable%*constant#regexp##regexp#**constant#regexp#' )
    multiple.is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    multiple[ 0 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 1 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 2 ].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    multiple[ 3 ].is_a?( ::Magnets::Path::PathPart::Fragment::WildcardFragment ).should == true
    multiple[ 4 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 5 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 6 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    multiple[ 7 ].is_a?( ::Magnets::Path::PathPart::Fragment::MultipathWildcardFragment ).should == true
    multiple[ 8 ].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    multiple[ 9 ].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
  end

  #######################################
  #  self.parse_string_for_descriptors  #
  #######################################

  it 'can take a descriptor string and parse it into corresponding objects' do

    ::Magnets::Path::PathPart.parse_string_for_descriptors( '#regexp#' )[ 0 ].is_a?( ::Magnets::Path::PathPart::Regexp ).should == true
    ::Magnets::Path::PathPart.parse_string_for_descriptors( '%variable%' )[ 0 ].is_a?( ::Magnets::Path::PathPart::Variable ).should == true
    ::Magnets::Path::PathPart.parse_string_for_descriptors( 'constant' )[ 0 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    
    path_parts = ::Magnets::Path::PathPart.parse_string_for_descriptors( 'some/path/part/#regexp#/#regexp#const%variable_name%/constant/%variable_name%**constant/endpath' )
    path_parts.count.should == 8
    path_parts[ 0 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    path_parts[ 1 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    path_parts[ 2 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    path_parts[ 3 ].is_a?( ::Magnets::Path::PathPart::Regexp ).should == true
    path_parts[ 4 ].is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    path_parts[ 4 ][0].is_a?( ::Magnets::Path::PathPart::Fragment::RegexpFragment ).should == true
    path_parts[ 4 ][1].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    path_parts[ 4 ][2].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    path_parts[ 5 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    path_parts[ 6 ].is_a?( ::Magnets::Path::PathPart::Multiple ).should == true
    path_parts[ 6 ][0].is_a?( ::Magnets::Path::PathPart::Fragment::VariableFragment ).should == true
    path_parts[ 6 ][1].is_a?( ::Magnets::Path::PathPart::Fragment::MultipathWildcardFragment ).should == true
    path_parts[ 6 ][2].is_a?( ::Magnets::Path::PathPart::Fragment::ConstantFragment ).should == true
    path_parts[ 7 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
    
  end
  
end
