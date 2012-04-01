
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------------  Array  -----------------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../lib/magnets-path.rb'

describe Array do

	#########################
	#  nested_permutations  #
	#########################

  it 'can perform a nested permutation' do

    unnested = [ :option1, :option2 ]
    unnested.nested_permutations.should == [ [ :option1, :option2 ] ]

    simple_nested = [ :option1, :option2, [ :option3 ] ]
    simple_nested.nested_permutations.should == [ [ :option1, :option2, :option3 ],
                                                  [ :option1, :option2 ] ]

    double_nested = [ :option1, [ :option2 ], [ :option3, :option4 ] ]
    double_nested.nested_permutations.should == [ [ :option1, :option2, :option3, :option4 ],
                                                  [ :option1, :option3, :option4 ],
                                                  [ :option1, :option2 ],
                                                  [ :option1 ] ]

    triple_nested = [ :option1, [ :option2 ], [ :option3, :option4 ], [ :option5 ] ]
    triple_nested.nested_permutations.should == [ [ :option1, :option2, :option3, :option4, :option5 ],
                                                  [ :option1, :option3, :option4, :option5 ],
                                                  [ :option1, :option2, :option3, :option4 ],
                                                  [ :option1, :option3, :option4 ],
                                                  [ :option1, :option2, :option5 ],
                                                  [ :option1, :option5 ],
                                                  [ :option1, :option2 ],
                                                  [ :option1 ] ]

    deep_nested = [ :option1, :option2, [ :option3, [ :option4, [ :option5 ] ], [ :option6, :option7] ], :option8 ]
    deep_nested.nested_permutations.should == [ [ :option1, :option2, :option3, :option4, :option5, :option6, :option7, :option8 ],
                                                [ :option1, :option2, :option3, :option4, :option6, :option7, :option8 ],
                                                [ :option1, :option2, :option3, :option4, :option5, :option8 ],
                                                [ :option1, :option2, :option3, :option6, :option7, :option8 ],
                                                [ :option1, :option2, :option3, :option4, :option8 ],
                                                [ :option1, :option2, :option3, :option8 ],
                                                [ :option1, :option2, :option8 ] ]

  end

end
