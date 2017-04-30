#! /bin/bash
#
# watch.sh 
# Invoke this script with one argument 'Megabytes size'
# bash watch.sh 10 & / this indicate 10mb file size  


# Destination/WatchPath/PCAPPATH should be replaced with actual path
DESTINATION=('/root/dir/one' '/root/dir/two')
PCAPPATH='/root/pcaps'
args=("$@")
INDEX=0


if [ $# -eq 1 ]; then
  SIZE=${args[0]}
else
  echo "You have to pass moving file size"
  exit
fi

inotifywait -m ${PCAPPATH} -e create |
while read path action file; do
  # TODO(ejsohn) : Erace all echo commands
  echo "The file '$file' appeared in directory '$path' via '$action'"

  for eachfile in $path*; do 
    
    # Bytes size
    filesizebyte=$( wc -c $eachfile | awk '{print $1}')
    # Megabytes size
    let "filesizembyte=${filesizebyte}/1000000"

    if [ $filesizembyte -ge $SIZE ]; then
    
      mv $eachfile ${DESTINATION[$INDEX]}
    
      if [ $INDEX -eq 0 ]; then
    
        let 'INDEX+=1'
    
      else
      
        let 'INDEX-=1'
      
      fi 
    
    fi
  
  done

done &

# Start generating pcaps
date +'%Y-%m-%d_%H:%M:%S' |
xargs -I {} bash -c "sudo tcpdump -C $SIZE -Z root -i wlx7cdd90e15d32 -w $PCAPPATH/{}.pcap" &
