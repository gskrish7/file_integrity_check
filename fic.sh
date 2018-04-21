db_file=~/my.db
chk_sum=/usr/bin/md5sum
respond=false

create_db()
{
  if [ ! -e $1 ]; then
    echo "$1 doesn't exist!"
    exit
  fi
  
  touch $db_file
  chmod u+rw $db_file
  echo > $db_file

  for i in $(find $1 -name "*"); do
    echo "`$chk_sum $i`" >> $db_file
  done
  
  chmod u-w $db_file
  echo "Created db file: $db_file"
}

check_file_status()
{
  echo $1
  db_hash=$(grep "$1" $db_file)
  echo $db_bash
  if [ -z "$db_hash" ]; then
    echo "File $1 not in db"
    if $respond; then
      rm -v $1
    fi
    return
  fi
  cr_hash=$(echo "`$chk_sum $1`")
  #echo "`$chk_sum $1/$tgfile`"
  #echo "dddd $db_hash:::$cr_hash"
  if [ "$db_hash" != "$cr_hash" ]; then
    echo "File modified [hash differ from db]"
  fi
}

scan_fs()
{
  if [ ! -e $1 ]; then
    echo "$1 doesn't exist!"
    exit
  fi

  while :
  do
    #tgfile=$(inotifywait -e close_write -e attrib $1 | grep -oE '[^ ]+$' 2> /dev/null)
    op=$(inotifywait -e close_write \
                     -e attrib \
                     -e create \
                     -e delete \
                     --exclude '(.*swp|.*~|4913)'  $1)

    tgfile=$(echo $op | awk '{print $NF}')

    case $op in
      *CREATE*)
        echo "File $1/$tgfile created"
        check_file_status  $1/$tgfile
        ;;
      *ATTRIB*)
        echo "File $tgfile Attribute changed"
        ;;
      *CLOSE_WRITE*)
        echo "File $1/$tgfile modified"
        check_file_status $1/$tgfile
        ;;
      *DELETE*)
        echo "File $tgfile deleted"
        ;;
      *)
        echo "Unknown operation"
    esac      
    echo "---------------------------------------"
  done

}

case $1 in
  --create)
    create_db $2
    ;;
  --scan)
    scan_fs $2
    echo "Scanning fs against db created"
   ;;
  *)
    echo "./fic [--create | --scan] <full-path>"
    ;;
esac
