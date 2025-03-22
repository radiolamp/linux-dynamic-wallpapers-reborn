# This code is distributed under the Apache License, Version 2.0.
# The full text of the license can be found in the LICENSE file or at: https://www.apache.org/licenses/LICENSE-2.0

project('Dynamic_Wallpapers', 'c')

prefix = '/usr'

dynamic_wallpapers_install_dir = join_paths(prefix, 'share', 'backgrounds', 'Dynamic_Wallpapers')
xml_install_dir = join_paths(prefix, 'share', 'gnome-background-properties')

install_subdir('Dynamic_Wallpapers', install_dir: dynamic_wallpapers_install_dir, strip_directory: true)

xml_files = run_command('find', 'xml', '-name', '*.xml', check: true).stdout().strip().split('\n')

foreach xml_file : xml_files
  install_data(xml_file, install_dir: xml_install_dir)
endforeach
