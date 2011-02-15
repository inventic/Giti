# Installation

    git clone git@github.com:inventic/Giti.git
    cp Giti/giti.sh /usr/local/bin/giti
    chmod +x /usr/local/bin/giti

# Example

    (1:130)$ giti
    Usage: -t target [-r -h -l]


    (1:135)$ giti -t test giti.sh
    Enter giti target directory [/tmp/backup]: /home/tx/.devel/backup
    Target directory already exists. Exiting...


    (1:131)$ giti -t work giti.sh 
    Target directory /home/tx/.devel/backup/workdir/work doesn't exists.
    Do You wanna create it [y/n]? y
    Enter full git clone/push repository path: ssh://git@scm.inventic.it/inventic/work-backup.git


    (1:137)$ giti -t work giti.sh 
    Copy [file] /home/tx/.devel/_projects/inventic-labs/web-app/htdocs/p/giti.sh to /home/tx/.devel/backup/workdir/work/inv0/home/tx/.devel/_projects/inventic-labs/web-app/htdocs/p/


    $GITI_HOME_DIR / $REPOSITORY / $HOSTNAME / $DIRECTORY_REALPATH / $TARGET_FILE


    (1:442)$ giti -l
    test work
    