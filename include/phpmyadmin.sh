#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://blog.linuxeye.cn
#
# Notes: OneinStack for CentOS/RedHat 6+ Debian 7+ and Ubuntu 12+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/lj2007331/oneinstack
#       https://github.com/tekintian/oneinstack_mphp

Install_phpMyAdmin() {
  pushd ${oneinstack_dir}/src > /dev/null
  PHP_detail_ver=`${php_install_dir}/bin/php -r 'echo PHP_VERSION;'`
  PHP_main_ver=${PHP_detail_ver%.*}
  if [[ "${PHP_main_ver}" =~ ^5.[3-4]$ ]]; then
    tar xzf phpMyAdmin-${phpmyadmin_oldver}-all-languages.tar.gz
    /bin/mv phpMyAdmin-${phpmyadmin_oldver}-all-languages ${wwwroot_dir}/default/phpMyAdmin
  else
    tar xzf phpMyAdmin-${phpmyadmin_ver}-all-languages.tar.gz
    /bin/mv phpMyAdmin-${phpmyadmin_ver}-all-languages ${wwwroot_dir}/default/phpMyAdmin
  fi
  /bin/cp ${wwwroot_dir}/default/phpMyAdmin/{config.sample.inc.php,config.inc.php}
  mkdir ${wwwroot_dir}/default/phpMyAdmin/{upload,save}
  sed -i "s@UploadDir.*@UploadDir'\] = 'upload';@" ${wwwroot_dir}/default/phpMyAdmin/config.inc.php
  sed -i "s@SaveDir.*@SaveDir'\] = 'save';@" ${wwwroot_dir}/default/phpMyAdmin/config.inc.php
  sed -i "s@blowfish_secret.*;@blowfish_secret\'\] = \'$(cat /dev/urandom | head -1 | base64 | head -c 45)\';@" ${wwwroot_dir}/default/phpMyAdmin/config.inc.php
  chown -R ${run_user}.${run_user} ${wwwroot_dir}/default/phpMyAdmin
  popd
}
