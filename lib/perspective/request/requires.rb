
basepath = 'path'

files = [
  'path_part/empty',
  'path_part/constant',
  'path_part/variable',
  'path_part/optional/interface',
  'path_part/optional',
  'path_part/optional/named_optional/interface',
  'path_part/optional/named_optional',
  'path_part/regexp',
  'path_part/multiple',
  'path_part/multiple/multipath_variable',
  'path_part/fragment/constant_fragment',
  'path_part/fragment/exclusion_fragment',
  'path_part/fragment/regexp_fragment',
  'path_part/fragment/variable_fragment',
  'path_part/fragment/multipath_variable_fragment',
  'path_part/fragment/optional_fragment',
  'path_part/fragment/optional_fragment/named_optional_fragment',
  'path_part/fragment',
  'path_part',
  'request_path/frame',
  'request_path',
  'parser'
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
