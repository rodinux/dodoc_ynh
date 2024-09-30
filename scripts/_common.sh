#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

nodejs_version="20.17.0"


_install_or_upgrade_chrome() {
    chrome_exec=''
        #install chrome dependencies as now chrome is 64bits and they are not installed by default
        ynh_apt_install_dependencies libgbm1 libpango-1.0-0 libpangocairo-1.0-0 libcairo2 libasound2 libdrm2 libatk-bridge2.0-0 libatk1.0-0 libnss3 libxkbcommon0 libxrandr2 libxfixes3 libxcomposite1 libxdamage1

        # instruct puppeteer to install chrome
        local puppeeterDir="$install_dir/.cache/puppeteer"
        if [[ -e "$puppeeterDir/chrome" ]] || [[ -L "$puppeeterDir/chrome" ]]; then 
            # Remove old versions of chrome
            ynh_safe_rm "$puppeeterDir/chrome"
        else
            mkdir --parents $puppeeterDir
            chown "$app:$app" $puppeeterDir
            chmod o-rwx,gu=rwx $puppeeterDir
        fi

        pushd "$puppeeterDir"
            ynh_exec_as_app $nodejs_dir/npx --yes @puppeteer/browsers install chrome@stable > browsers.txt
            chrome_exec=$(awk '/\S/{ s=$NF; } END{ print(s); }' browsers.txt)
        popd

}