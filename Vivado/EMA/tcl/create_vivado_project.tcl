set origin_dir "../"

## Project parameters
set project_name "prj"
set project_path "${origin_dir}/build"
set target_part  "xczu5cg-sfvc784-2L-e"

## Defiene source files

set src_files [list \
  "${origin_dir}/src/Test1.v" \
  "${origin_dir}/src/Module_of_number.v" \
  "${origin_dir}/src/EMA_Module_30_06.v" \
]

## Create project
create_project $project_name $project_path -part $target_part -force

add_files $src_files



close_project