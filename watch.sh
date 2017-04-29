#! /bin/bash
#
# watch.sh 
# Invoke this script with one argument 'size'
# bash watch.sh 10 & / this indicate 10mb file size  

# Destination/WatchPath should be replaced with actual path
DESTINATION=('/home/vagrant/node-one' '/home/vagrant/node-two')
WATCHPATH='/home/vagrant/root'
args=("$@")
INDEX=0


if [ $# -eq 1 ]; then
  SIZE=${args[0]}
else
  echo "You have to pass moving file size"
  exit
fi

inotifywait -m ${WATCHPATH} -e create |
while read path action file; do
  # TODO(ejsohn) : Erace all echo commands
  echo "The file '$file' appeared in directory '$path' via '$action'"

  for eachfile in $path*; do 
    
    filesize=$( wc -c $eachfile | awk '{print $1}')
    
    if [ $filesize -ge $SIZE ]; then
    
      mv $eachfile ${DESTINATION[$INDEX]}
    
      if [ $INDEX -eq 0 ]; then
    
        let 'INDEX+=1'
    
      else
      
        let 'INDEX-=1'
      
      fi 
    
    fi
  
  done

done
