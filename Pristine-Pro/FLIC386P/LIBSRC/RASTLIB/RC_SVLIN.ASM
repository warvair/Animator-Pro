;generated via makeasms.bat
	include raster.i
	include rastlib.i

CGROUP	group	code

code	segment dword 'CODE'
	assume cs:CGROUP,ds:CGROUP

RASTLIB_JUMP pj__set_vline RL_SET_VLINE 

code	ends
	end
