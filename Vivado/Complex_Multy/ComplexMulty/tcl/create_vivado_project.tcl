set origin_dir "../"

## Project parameters
set project_name "prj"
set project_path "${origin_dir}/build"
set target_part  "xczu5cg-sfvc784-2L-e"

## Defiene source files

set src_files [list \
  "${origin_dir}/src/complex_mult.v" \
]

set tb_files [list \
  "${origin_dir}/src/tb_complex_mult.sv" \
]

## Create project
create_project $project_name $project_path -part $target_part -force

add_files $src_files
add_files $tb_files -fileset sim_1


close_project