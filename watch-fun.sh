#! /bin/bash
#
# watch.sh 
# File distributing functions


#########################################################
# Watch a directory and catch & throwing generated files
# Arguments:
#   SIZE 
#       - Megabytes integer size of wanted file.
#   PCAPPATH
#       - Array
#       - Scheme ("watching-dir" 
#                 "throwing-destination-one" 
#                 "throwing-destination-two")
# Return:
#   None
#########################################################
function watch() {
  INDEX=1
  SIZE="${1}"
  PCAPPATH=("${@}")
  
  inotifywait -m ${PCAPPATH[0]} -e create |
  while read path action file; do
    # TODO(ejsohn) : Erace all echo commands
    echo "The file '$file' appeared in directory '$path' via '$action'"
    
    for eachfile in $path*; do 
    
      # Bytes size
      filesizebyte=$( wc -c $eachfile | awk '{print $1}')
      # Megabytes size
      let "filesizembyte=${filesizebyte}/1000000"

      if [ $filesizembyte -ge $SIZE ]; then
    
        mv $eachfile ${PCAPPATH[$INDEX]}
    
        if [ $INDEX -eq 1 ]; then
    
          let 'INDEX+=1'
    
        else
      
          let 'INDEX-=1'
      
        fi 
    
      fi
  
    done

  done 
}


#########################################################
# Tcpdump function with some options
# Arguments:
#   SIZE 
#       - Megabytes integer size of wanted file.
#   PCAPPATH
#       - Directory where pcaps generated in.
# Return:
#   None
#########################################################
function dumping() {
  SIZE="${1}"
  PCAPPATH="${2}"
  # Start generating pcaps
  date +'%Y-%m-%d_%H:%M:%S' |
  xargs -I {} bash -c "sudo tcpdump -C $SIZE -Z root -i wlx7cdd90e15d32 -w $PCAPPATH/{}.pcap" 
}


export -f watch
export -f dumping
