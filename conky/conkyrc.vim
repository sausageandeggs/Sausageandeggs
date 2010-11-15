" Vim syntax file
" Language:	conkyrc
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Modifications: Simon Stoakley <sausageandeggs at archlinux dot us>
" Version:	20100211
" Copyright:	Copyright (c) 2005 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself

if exists("b:current_syntax")
  finish
endif

syn region ConkyrcComment start=/^\s*#/ end=/$/
"syn match	ConkyrcComment		"^\s*\zs#.*$"
"syn match	ConkyrcComment		"\s\zs#.*$"	
"syn match	ConkyrComment		"#.*$"

syn keyword ConkyrcSetting
	\ alignment background on_bottom border_margin border_width cpu_avg_samples
	\ default_color default_shade_color default_outline_color double_buffer
	\ draw_borders draw_shades draw_outline font gap_x gap_y no_buffers
	\ mail_spool maximum_width minimum_size mldonkey_hostname mldonkey_port
	\ mldonkey_login mldonkey_password mpd_host mpd_port mpd_password
	\ net_avg_samples override_utf8_locale own_window own_window_transparent
	\ own_window_colour pad_percents stippled_borders total_run_times
	\ update_interval uppercase use_spacer use_xft xftalpha draw_graph_borders 
	\ max_specials max_user_text own_window_hints own_window_type short_units 
	\ text_buffer_size border_inner_margin border_outer_margin xftfont

syn keyword ConkyrcConstant yes no top_left top_right bottom_left bottom_right none

syn match ConkyrcNumber /\S\@<!\d\+\(\.\d\+\)\?\(\S\@!\|}\@=\)/
      \ nextgroup=ConkyrcNumber,ConkyrcColour skipwhite
syn match ConkyrcColour /\S\@<!#[a-fA-F0-9]\{6\}\(\S\@!\|}\@=\)/
      \ nextgroup=ConkyrcNumber,ConkyrcColour skipwhite

syn region ConkyrcText start=/^TEXT$/ end=/\%$/ contains=ConkyrcVar,ConkyrcComment

syn region ConkyrcVar start=/\${/ end=/}/ contained contains=ConkyrcVarStuff
syn region ConkyrcVar start=/\$\w\@=/ end=/\W\@=\|$/ contained contains=ConkyrcVarName

syn match ConkyrcVarStuff /{\@<=/ms=s contained nextgroup=ConkyrcVarName

syn keyword ConkyrcVarName1 
      \ addr acpiacadapter acpifan acpitemp acpitempf adt746xcpu
      \ adt746xfan apm_adapter apm_battery_life apm_battery_time
      \ battery buffers cached color color0 color1 color2 color3 cpu cpubar 
	  \ colour diskio downspeed downspeedf color4 color5 color6
      \ colour else exec execbar execgraph execi execpi execibar execigraph font freq
      \ freq_g freq_dyn freq_dyn_g fs_bar fs_free fs_free_perc fs_size fs_used head
      \ hr i2c i8k_ac_status i8k_bios i8k_buttons_status i8k_cpu_temp i8k_cpu_tempf
      \ i8k_left_fan_rpm i8k_left_fan_status i8k_right_fan_rpm i8k_right_fan_status
      \ i8k_serial i8k_version if_running if_existing if_mounted kernel linkstatus loadavg
      \ machine mails mem membar memmax memperc ml_upload_counter ml_download_counter
      \ ml_nshared_files ml_shared_counter ml_tcp_upload_rate ml_tcp_download_rate
      \ ml_udp_upload_rate ml_udp_download_rate ml_ndownloaded_files ml_ndownloading_files
      \ mpd_artist mpd_album mpd_bar mpd_bitrate mpd_status mpd_title mpd_vol mpd_elapsed
      \ mpd_length mpd_percent new_mails nodename outlinecolor pre_exec processes
      \ running_processes shadecolor stippled_hr swapbar swap swapmax swapperc sysname
      \ texeci offset tail time totaldown top top_mem totalup updates upspeed upspeedf
      \ upspeedgraph uptime uptime_short seti_prog seti_progbar seti_credit Arial\* Arial:
	  \ 
syn keyword ConkyrcVarName 
      \ addr acpiacadapter acpifan acpitemp acpitempf adt746xcpu
      \ adt746xfan apm_adapter apm_battery_life apm_battery_time
      \ battery buffers cached color color0 color1 color2 color3 cpu cpubar 
	  \ colour diskio downspeed downspeedf color4 color5 color6
      \ colour else exec execbar execgraph execi execpi execibar execigraph font freq
      \ freq_g freq_dyn freq_dyn_g fs_bar fs_free fs_free_perc fs_size fs_used head
      \ hr i2c i8k_ac_status i8k_bios i8k_buttons_status i8k_cpu_temp i8k_cpu_tempf
      \ i8k_left_fan_rpm i8k_left_fan_status i8k_right_fan_rpm i8k_right_fan_status
      \ i8k_serial i8k_version if_running if_existing if_mounted kernel linkstatus loadavg
      \ machine mails mem membar memmax memperc ml_upload_counter ml_download_counter
      \ ml_nshared_files ml_shared_counter ml_tcp_upload_rate ml_tcp_download_rate
      \ ml_udp_upload_rate ml_udp_download_rate ml_ndownloaded_files ml_ndownloading_files
      \ mpd_artist mpd_album mpd_bar mpd_bitrate mpd_status mpd_title mpd_vol mpd_elapsed
      \ mpd_length mpd_percent new_mails nodename outlinecolor pre_exec processes
      \ running_processes shadecolor stippled_hr swapbar swap swapmax swapperc sysname
      \ texeci offset tail time totaldown top top_mem totalup updates upspeed upspeedf
      \ upspeedgraph uptime uptime_short seti_prog seti_progbar seti_credit Arial\* Arial:
	  \ 

syn keyword ConkyCmd execpi execp execi exec

syn keyword ConkyFmat voffset offset goto alignr alignc 

syn region shCommandSub matchgroup=String start="\${"  end="}"  contains=ConkyrcVarstuff,ConkyrcVar,ConkyCmd,ConkyrcText,ConkyrcColour,ConkyrcNumber,ConkyrcSetting,ConkyrcConstant,ConkyCmd,ConkyFmat,ConkyrcVarName
    

hi def link ConkyrcComment   Comment
hi def link ConkyrcSetting   Statement
hi def link ConkyrcConstant  Constant
hi def link ConkyrcNumber    Number
hi def link ConkyrcColour    Special
hi def link ConkyCmd 		 Repeat
hi def link ConkyrcVar       Identifier
hi def link ConkyrcVarName1  Keyword
hi def link ConkyrcVarName   Question
hi def link ConkyrcText      String
hi def link ConkyFmat  		 netrwTime

let b:current_syntax = "conkyrc"

