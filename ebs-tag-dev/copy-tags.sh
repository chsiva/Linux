
regionid=us-east-1
# Look for all EC2 instances and add the IDs to an array
 echo "Checking for EC2 instances."
 instarr=( $(aws ec2 describe-instances --region ${regionid} --filters Name=vpc-id,Values=vpc-166a6e6e --query 'Reservations[*].Instances[*].{ID:InstanceId}' --output text) )

# Cycle through each instance in the array
 echo "EC2 instance list created."
 for instid in "${instarr[@]}"
 do
    printf "\n"
    echo "Querying instance-id: " ${instid} "for tag contents..."
    
    #echo "All Tag pairs found: " ${tagpairs}    
    
    tagkeys=`aws ec2 describe-tags --region ${regionid} --filters "Name=resource-id,Values=${instid}" "Name=key,Values=*" --query Tags[].{Key:Key} --output text`
    echo "Application tag keys found: " ${tagkeys}
    totalkeyscount=`echo ${tagkeys} | wc -w`
    echo "Total Keys: " $totalkeyscount

    # Read Tags for instance into variable
    tagvalues=`aws ec2 describe-tags --region ${regionid} --filters "Name=resource-id,Values=${instid}" "Name=key,Values=*" --query Tags[].{Value:Value} --output text`
    echo "Application tag value found: " ${tagvalues}
    totalvaluecount=`echo ${tagvalues} | wc -w`
    echo "Total Values: " $totalvaluecount

    # Define the arrays
    keyarr=(${tagkeys// / })
    valuearr=(${tagvalues// / })
    
    # Get volume-ids of all volumes attached to instance
    echo "Locating volumes attached to " ${instid}
    volidarr=( $(aws ec2 describe-volumes --region ${regionid} --filters Name=attachment.instance-id,Values=${instid} --query 'Volumes[*].Attachments[*].{volid:VolumeId}' --output text) )

    # Populate the Application tag for all volumes
    for volid in ${volidarr[@]}
    do
        echo "Volume found.  Adding tag data to volume-id: " ${volid}        
         
        data=`aws ec2 describe-tags --filters "Name=resource-id,Values=${volid}" "Name=key,Values=*" --query Tags[].{Key:Key} --output text`
        existingkeyarr=(${data// / })
        totalexistingkeys=${#existingkeyarr[@]}
        volumeExistingkeys=${existingkeyarr[@]}
        echo "Existing keys $volumeExistingkeys on volume $volid"
        echo "Lengh of existing keys $totalexistingkeys on volume $volid"
        shopt -s nocasematch
        
          for ((i=0;i<$totalkeyscount;i++)); 
          do
            
            ec2tagkey=${keyarr[$i]} 
                        
                
                isTagExists=$(sh vars/function.sh isMatched $ec2tagkey "$volumeExistingkeys")
                echo "\t\t\tis tag >$ec2tagkey< exists in >$volumeExistingkeys< : $isTagExists"
                if [ "$isTagExists" == "unmatched" ]; then
                  echo "\t\t\tapplying tag $ec2tagkey on volume $volid"
                  aws ec2 create-tags --region ${regionid} --resources ${volid} --tags Key="${keyarr[$i]}",Value="${valuearr[$i]}"
                fi
                echo ""
              
          done
                  
        echo "Done!"
    done

done
