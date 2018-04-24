$cmp={
	name=>'MyModul',
	file=>'MyModul.h',
	comp=>[
	{
		name=>'FastImpl',
		depends=>'&hurry_up',
		file=> 'MyModul.c',
		srcfile=>'MyModul_fast.c'
	
	},
	{
		name=>'SlowImpl',
		depends=>'not &hurry_up',
		file=> 'MyModul.c',
		srcfile=>'MyModul_slow.c'
	},
	{
		file=>'optimizable.c',
		depends=>'&hurry_up and &compiler_can_optimize'
	}
	]
};
