In dump dir you may find flash image dump (use losetup in Linux to mount it and partprobe to find gpt partitions) and backup of tf card

To enable ADB and disable stupid button leds - copy or create `firmware` dir in TF-card and place `update.sh` and `usrrun.sh` scripts into it (from `adb_ledoff` dir)

