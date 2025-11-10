#cloud-config
package_update: true
package_upgrade: false

users:
  - name: ${user_name}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash

packages:
  - gdebi-core
  - net-tools
  # Install git
  - git
  # Install nginx
  - nginx
  # Java runtime environment
  - default-jre
  # Java development kit
  - default-jdk
  - software-properties-common
  - dirmngr
  - libcurl4-gnutls-dev
  - libxml2-dev
  - libssl-dev
  - libfontconfig1-dev 
  
runcmd:
  - apt-get update
  ### update indices
  - apt update -qq

  ### add the signing key (by Michael Rutter) for these repos
  ### To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
  ### Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
  - wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

  ### add the repo from CRAN -- lsb_release adjusts to 'noble' or 'jammy' or ... as needed
  - add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

  ### Swap 1GB of Memory to create more space on your server
  - /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
  - /sbin/mkswap /var/swap.1
  - /sbin/swapon /var/swap.1
  - sh -c 'echo "/var/swap.1 swap swap defaults 0 0 " >> /etc/fstab'
  - echo "1GB of swapspace has been added to your server"

  ### install R itself  
  - apt install r-base-core -y
  
   # Install devtools dependencies     
  - echo "Devtools dependencies have been installed on your server"
  - sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
  - sudo su - -c "R -e \"devtools::install_github('daattali/shinyjs')\""  
  - wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.2-418-amd64.deb
  - sudo gdebi -n rstudio-server-2025.09.2-418-amd64.deb
  - echo "Rstudio-Server has been installed on your server"

  ###Install R-Shiny dependency needed for Shiny-Server build
  - sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""                                                                                    
  
  ### Install latest verison of R Shiny-Server
  - wget wget https://download3.rstudio.org/ubuntu-20.04/x86_64/shiny-server-1.5.23.1030-amd64.deb
  - sudo gdebi -n shiny-server*.deb
  - echo "Shiny-Server had been installed on your server"
  
  ###Setup proper permissions for shiny and your user
  - sudo groupadd shiny-apps
  - sudo usermod -aG shiny-apps ${user_name}
  - sudo usermod -aG shiny-apps shiny
  - cd /srv/shiny-server
  - sudo chown -R ${user_name}:shiny-apps .
  - sudo chmod g+w .
  - sudo chmod g+s .
  - git config --global user.email "${github_email}"
  - git config --global user.name "${github_username}"  
  
  ###Initialize git on your shiny-server
  - cd /srv/shiny-server
  - git init

  ##Update where R expects to find various Java files
  - sudo R CMD javareconf
  
  ##Adjust the slugs to work with /rstudio /shiny
  - systemctl restart nginx    
  
write_files:
  - path: /var/www/html/index.html
    content: |
      <!DOCTYPE html>
      <html>
      <head>
          <title>Welcome to Your Rstudio/Shiny Server Droplet!</title>
      </head>
      <body>
          <h1>Hello, DigitalOcean!</h1>
          <p>This page is served by Nginx which is running on your droplet.</p>
      </body>
      </html>
    permissions: '0644'  
    
  - path: /etc/nginx/sites-available/default 
    content: |
      map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
      }

      server {
        listen 80;
        server_name _;

        location /shiny/ {
            proxy_pass http://127.0.0.1:3838/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            rewrite ^(/shiny/[^/]+)$ $1/ permanent;
        }

        location /rstudio/ {
            proxy_pass http://127.0.0.1:8787/;;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
        }

        # Optional: redirect root to /rstudio/
        location = / {
            return 302 /rstudio/;
        }
      }
    permissions: '0644'      

final_message: "The system is finally up, and the Rstudio server is running on port 8787!"