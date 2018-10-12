#!/bin/bash
# Author:  Tekin <tekintian@gmail.com>
# BLOG:  https://github.com/tekintian/oneinstack_mphp
#
# adminer.php download
#

Install_adminer() {
  #del old adminer.php
   [ -e "${wwwroot_dir}/default/adminer.php" ] && rm -rf ${wwwroot_dir}/default/adminer.php
   #download adminer
   wget -c https://github.com/vrana/adminer/releases/download/v${adminer_ver}/adminer-${adminer_ver}.php -O ${wwwroot_dir}/default/adminer.php > /dev/null 2>&1
  chown -R ${run_user}.${run_user} ${wwwroot_dir}/default/adminer.php
  popd
}
