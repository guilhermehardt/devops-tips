#!/bin/bash


DEBUG=false

repositories=( "repo1" "repo2" )

[[ "${DEBUG}" = "true" ]] && printf "%s\n" "${repositories[@]}"

TOTAL_MB=0
TOTAL_REPO_MB=0
COUNT_UNTAGGED=0

for repository in "${repositories[@]}"; do
  echo "Calculating size of repository ${repository} ..."
  [[ "${DEBUG}" = "true" ]] && echo "List of images for repository ${repository} ..."
  image_tags=($(aws ecr list-images --repository-name ${repository} --query 'imageIds[].imageTag' --output text))
  [[ "${DEBUG}" = "true" ]] && printf "%s\n" "${image_tags[@]}"

  # ensure that size of repository is 0
  TOTAL_REPO_MB=0

  for image_tag in "${image_tags[@]}"; do
    # getting size for each image
    image_size_bytes=$(aws ecr describe-images --repository-name ${repository} --image-id imageTag=${image_tag} --query 'imageDetails[].imageSizeInBytes' --output text)
    if [ "$image_size_bytes" = "null" ]; then
      let COUNT_UNTAGGED+=1
    else
      # converting size value from bytes to megabytes
      image_size_mb=$(( ($image_size_bytes / 1000) / 1000))
      # adding value of each image
      let TOTAL_REPO_MB+=$image_size_mb
      [[ "${DEBUG}" = "true" ]] && echo "REPO: ${repository} -- IMAGE: ${image_tag} -- SIZE ${image_size_mb} MB"
    fi
  done
  let TOTAL_MB+=TOTAL_REPO_MB
  echo "The size is ${TOTAL_REPO_MB} MB"
done

echo "# The size of all repositories is ${TOTAL_MB} MB"
