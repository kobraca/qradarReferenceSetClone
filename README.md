# qradarReferenceSetClone

This script created for transporting Reference Sets from one QRadar console to another QRadar console.

  - To perform this action, consoles had to connect via ssh access.
  - Script contains just 2 functions which save and load ReferenceSets between QRadar Consoles.
  - First function pass first argument as Reference Set name and second as file name and saved data.
  - Second function pass first argument as IP address, second as filename and third as Reference Set name and loaded data to another QRadar console.
  - You need to create reference sets by manually.
  - You can transfer more Reference Sets with editing this script.
