#!/usr/bin/fish
# Mirroring script written in fish by Azzen <github.com/azzen>
# last update 2020-06-18 09:25:59
# Be careful when using it, there is no test whatsoever, it MAY remove unexpected files!

if test -e mirror.conf
    source mirror.conf
    echo -e "\r\e[34mStarting mirroring to sftp://$user:@$address\e[35m"
    lftp -c "
    set ssl:verify-certificate no;
    set sftp:auto-confirm yes;
    set sftp:connect-program 'ssh -v -a -x -i $ssh_file';
    open sftp://$user:$pass@$address;
    lcd '$absolute_client_path_to_gamemode';
    cd '$absolute_server_path_to_gamemode';
    mirror --reverse --delete --verbose --use-cache \
    --parallel=4 --no-perms --exclude .git/ \
    --exclude-glob *.conf --exclude-glob *.sh --exclude-glob *.example;
    lcd '$absolute_client_path_to_addons';
    cd '$absolute_server_path_to_addons';
    mirror --reverse --delete --verbose --use-cache \
    --parallel=2 --no-perms --exclude .git/ \
    --exclude-glob *.conf --exclude-glob *.sh --exclude-glob *.example;"
    echo -e "\r\e[92mSuccessfully mirrored content to sftp://$user@$address\e[32m"
else
    echo -e "\r\e[91mAborting missing configuration file: mirror.conf\e[32m"
end


