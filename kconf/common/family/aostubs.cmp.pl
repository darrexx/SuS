$VAR1 = {
    'vname' => 'AOStuBS',
    'depends' => '&basisystem',
    'dir' => './',
    'comp' => [
    {
        'files' => ['config', 'main.cc', 'msp430.h', 'Makefile', 'scripts', 'device', 'guard', 'meeting', 'object', 'thread']
    },
    {
        'subdir' => 'machine',
        'files'=> [ 'buttons.cc',
                    'buttons.h',
                    'cpu.cc',
                    'cpu.h',
                    'lcd.cc',
                    'lcd.h',
                    'plugbox_vectors.h',
                    'standby.ah',
                    'standby.cc',
                    'standby.h',
                    'system.cc',
                    'system.h',
                    'timer.cc',
                    'timer.h',
                    'toc_asm.S',
                    'toc.c',
                    'toc.h',
                    'wrapper.c' ]
    },
    {
        'subdir' => 'syscall',
        'files'=> [ 'guarded_buzzer.cc',
                    'guarded_buzzer.h',
                    'guarded_organizer.cc',
                    'guarded_organizer.h',
                    'guarded_semaphore.cc',
                    'guarded_semaphore.h',
                    'thread.h' ]
    },
    {
		'subdir' => 'user',
		'files' => 'userthread.(cc|h)'
    },
    {
        'vname' => 'Simplicity Networking Stack',
        'depends' => '&simplicity',
        'comp' => [
        {
            'subdir' => 'machine',
            'comp' => [
            {
                'vname' => 'Radio',
                'files'=>'radio.(cc|h|ah)',
            },
            {
                'vname' => 'Simplicity',
                'file'=>'simpliciti'
            }
            ]
        },
        {
            'vname' => 'Guarded Radio',
            'subdir' => 'syscall',
            'files'=>'guarded_radio.(cc|h)'
        }
        ]
    },
    {
        'vname' => 'SCP1000',
        'depends' => '&scp1000',
        'comp' => [
        {
            'subdir' => 'machine',
            'files'=> 'scp1000.(cc|h|ah)'
        },
        {
            'subdir' => 'syscall',
            'files'=> 'guarded_scp1000.(cc|h)'
        }
        ]
    },
    {
        'vname' => 'Accelerometer',
        'depends' => '&accel',
        'comp' => [
        {
            'subdir' => 'machine',
            'files'=> 'accel.(cc|h|ah)'
        },
        {
            'subdir' => 'syscall',
            'files'=> 'guarded_accel.(cc|h)'
        }
        ]
    },
    {
        'vname' => 'Realtime Clock',
        'depends' => '&rtc',
        'comp' => [
        {
            'subdir' => 'machine',
            'files'=> 'rtc.(cc|h|ah)'
        },
        {
            'subdir' => 'syscall',
            'files'=> 'guarded_rtc.(cc|h)'
        }
        ]
    },
    {
        'vname' => 'UART',
        'depends' => '&uart',
        'comp' => [
        {
            'subdir' => 'machine',
            'files'=> 'uart.(cc|h|ah)'
        }
        ]
    },
    {
        'vname' => 'Piezo Beeper',
        'depends' => '&beeper',
        'comp' => [
        {
            'subdir' => 'machine',
            'files'=> 'beeper.(cc|h|ah)'
        }
        ]
    },
    {
        'vname' => 'Panic',
        'depends' => '&debug_panic',
        'subdir' => 'machine',
        'file' => 'show_panic.ah'
    },
    {
        'vname' => 'ShowIRQ',
        'depends' => '&debug_irq',
        'subdir' => 'machine',
        'file' => 'guardian_panic.ah'
    },
    {
        'vname' => 'Panic',
        'depends' => '&debug_guard',
        'subdir' => 'guard',
        'file' => 'locker_checking.ah'
    },
    {
    	'vname' => 'Eclipseproject',
	'depends' => '&eclipseproject',
        'files'=> ['.cproject', '.project']
    },
    {
		'vname' => 'Musterlösungen',
		'depends' => '&solutions',
		'comp' => [
		{
			'subdir' => 'machine',
			'file' => 'lcd.h',
			'srcfile' => 'lcd_solution.h',
		},
		{
			'subdir' => 'machine',
			'file' => 'lcd.cc',
			'srcfile' => 'lcd_solution.cc',
		},
		{
			'subdir' => 'machine',
			'file' => 'buttons.h',
			'srcfile' => 'buttons_solution.h',
		},
		{
			'subdir' => 'machine',
			'file' => 'buttons.cc',
			'srcfile' => 'buttons_solution.cc',
		},
		{
			'subdir' => 'user',
			'files' => 'lcdtestthread.(ah|h|cc)',
		},
		{
			'subdir' => 'user',
			'files' => 'schedulingthread.(ah|h|cc)',
		},
		{
			'subdir' => 'user',
			'files' => 'clickerthread.(ah|h|cc)',
		},
		{
			'subdir' => 'user',
			'files' => 'idlethread.(ah|h|cc)',
		},
		{
			'subdir' => 'user',
			'files' => 'senderthread.(ah|h|cc)',
		},
		{
			'subdir' => 'user',
			'files' => 'receiverthread.(ah|h|cc)',
		},
		{
			'subdir' => 'user',
			'files' => ['buttonthread.ah',
				'buttonthread.h',
				'buttonthread.cc',
				'clickcountingsemaphor.cc',
				'clickcountingsemaphor.h',
				'threadchangesemaphor.cc',
				'threadchangesemaphor.h',
				'displaythread.h',
				'displaythread.cc',
				'idle.ah',
				'hashsemaphor.h',
				'hashsemaphor.cc']
		},
		]
    },
    ]
};
