<?php
header('Content-Type: text/plain');
echo "--- RPi Dashboard Docker Debug ---\n\n";

echo "Current User: " . shell_exec('whoami') . "\n";
echo "System Time: " . date('Y-m-d H:i:s') . "\n";
echo "PATH: " . getenv('PATH') . "\n";
echo "LD_LIBRARY_PATH: " . getenv('LD_LIBRARY_PATH') . "\n\n";

echo "--- Hardware Checks ---\n";
echo "Proc Uptime: " . shell_exec('cat /proc/uptime') . "\n";
echo "Sys Temp Path Exists: " . (file_exists('/sys/class/thermal/thermal_zone0/temp') ? 'YES' : 'NO') . "\n";
echo "Sys Temp Value: " . shell_exec('cat /sys/class/thermal/thermal_zone0/temp') . "\n";
echo "CPU Load (PHP): " . print_r(sys_getloadavg(), true) . "\n";
echo "Free -m: \n" . shell_exec('free -m') . "\n";

echo "\n--- vcgencmd Check ---\n";
echo "vcgencmd which: " . shell_exec('which vcgencmd') . "\n";
echo "vcgencmd version: \n" . shell_exec('vcgencmd version') . "\n";
echo "vcgencmd measure_volts: " . shell_exec('vcgencmd measure_volts core') . "\n";

echo "\n--- Groups ---\n";
echo "Groups for www-data: " . shell_exec('groups www-data') . "\n";

echo "\n--- /opt/vc Check ---\n";
echo "ls -l /opt/vc: \n" . shell_exec('ls -l /opt/vc') . "\n";
?>
