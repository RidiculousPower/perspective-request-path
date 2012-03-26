
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------------  Hash  -----------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../lib/rmagnets-view-path.rb'

describe Hash do

	##################
	#  count_nested  #
	##################

  it 'can count the number of total elements including nested elements' do
    nested_hash = ::Rmagnets::ViewPath::Hash::Nested.new.merge( { :one => 1, :two => 2, :three => { :one => 1, :two => 2 } } )
    nested_hash.count.should == 4
    nested_hash = ::Rmagnets::ViewPath::Hash::Nested.new.merge( { :one => 1, :two => 2, :three => Rmagnets::ViewPath::Hash::Nested.new.merge( { :four => 4, :five => 5, :six => Rmagnets::ViewPath::Hash::Nested.new.merge( { :seven => 7, :eight => 8 } ) } ) } )
    nested_hash.count.should == 6
  end
  
	#########################
	#  nested_permutations  #
	#########################

  it 'can perform a nested permutation' do

    unnested = { :option_name1 => :option1, :option_name2 => :option2 }
    unnested.nested_permutations.should == [ { :option_name1 => :option1, :option_name2 => :option2 } ]

    simple_nested = { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3 } }
    simple_nested.nested_permutations.should == [ { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3 } },
                                                  { :option_name1 => :option1, :option_name2 => :option2 } ]

    double_nested = { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 }, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 } }
    double_nested.nested_permutations.should == [ { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 }, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 } },
                                                  { :option_name1 => :option1, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 } },
                                                  { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 } },
                                                  { :option_name1 => :option1 } ]

    triple_nested = { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 }, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 }, :option_group3 => { :option_name5 => :option5 } }
    triple_nested.nested_permutations.should == [ { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 }, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 }, :option_group3 => { :option_name5 => :option5 } },
                                                  { :option_name1 => :option1, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 }, :option_group3 => { :option_name5 => :option5 } },
                                                  { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 }, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 } },
                                                  { :option_name1 => :option1, :option_group2 => { :option_name3 => :option3, :option_name4 => :option4 } },
                                                  { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 }, :option_group3 => { :option_name5 => :option5 } },
                                                  { :option_name1 => :option1, :option_group3 => { :option_name5 => :option5 } },
                                                  { :option_name1 => :option1, :option_group1 => { :option_name2 => :option2 } },
                                                  { :option_name1 => :option1 } ]

    deep_nested = { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3, :option_group2 => { :option_name4 => :option4, :option_group3 => { :option_name5 => :option5 } }, :option_group4 => { :option_name6 => :option6, :option_name7 => :option7 } }, :option_name8 => :option8 }
    deep_nested.nested_permutations.should == [ { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3, :option_group2 => { :option_name4 => :option4, :option_group3 => { :option_name5 => :option5 } }, :option_group4 => { :option_name6 => :option6, :option_name7 => :option7 } }, :option_name8 => :option8 },
                                                { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3, :option_group2 => { :option_name4 => :option4 }, :option_group4 => { :option_name6 => :option6, :option_name7 => :option7 } }, :option_name8 => :option8 },
                                                { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3, :option_group2 => { :option_name4 => :option4, :option_group3 => { :option_name5 => :option5 } } }, :option_name8 => :option8 },
                                                { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3, :option_group4 => { :option_name6 => :option6, :option_name7 => :option7 } }, :option_name8 => :option8 },
                                                { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3, :option_group2 => { :option_name4 => :option4 } }, :option_name8 => :option8 },
                                                { :option_name1 => :option1, :option_name2 => :option2, :option_group1 => { :option_name3 => :option3 }, :option_name8 => :option8 },
                                                { :option_name1 => :option1, :option_name2 => :option2, :option_name8 => :option8 } ]

  end

end
