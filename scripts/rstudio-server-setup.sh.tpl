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
  - git
  - nginx
  - default-jre
  - default-jdk
  - software-properties-common
  - dirmngr
  - libcurl4-gnutls-dev
  - libxml2-dev
  - libssl-dev
  - libfontconfig1-dev

write_files:
  - path: /var/www/html/index.html
    owner: root:root
    permissions: '0644'
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

  - path: /etc/nginx/sites-available/default
    owner: root:root
    permissions: '0644'
    content: |
      map \$http_upgrade \$connection_upgrade {
          default upgrade;
          ''      close;
      }

      server {

          root /var/www/html;

          index index.html index.htm index.nginx-debian.html;

          server_name _;

          location /shiny/ {
              proxy_pass http://127.0.0.1:3838/;
              proxy_http_version 1.1;
              proxy_set_header Upgrade \$http_upgrade;
              proxy_set_header Connection \$connection_upgrade;
              rewrite ^(/shiny/[^/]+)$ \$1/ permanent;
          }

          location /rstudio/ {
              proxy_pass http://127.0.0.1:8787/;
              proxy_http_version 1.1;
              proxy_set_header Upgrade \$http_upgrade;
              proxy_set_header Connection \$connection_upgrade;
          }

          location / {
              try_files \$uri \$uri/ =404;
          }
      }

runcmd:
  - apt-get update -y
  - apt update -qq
  - wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  - add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
  - /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
  - /sbin/mkswap /var/swap.1
  - /sbin/swapon /var/swap.1
  - sh -c 'echo "/var/swap.1 swap swap defaults 0 0 " >> /etc/fstab'
  - echo "1GB of swapspace has been added to your server"
  - apt install -y r-base-core
  - echo "Installing devtools dependencies"
  - sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
  - sudo su - -c "R -e \"devtools::install_github('daattali/shinyjs')\""
  - wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.2-418-amd64.deb
  - sudo gdebi -n rstudio-server-2025.09.2-418-amd64.deb
  - echo "RStudio Server installed"
  - sudo su - -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""
  - wget https://download3.rstudio.org/ubuntu-20.04/x86_64/shiny-server-1.5.23.1030-amd64.deb
  - sudo gdebi -n shiny-server-1.5.23.1030-amd64.deb
  - echo "Shiny Server installed"
  - sudo groupadd shiny-apps || true
  - sudo usermod -aG shiny-apps ${user_name}
  - sudo usermod -aG shiny-apps shiny
  - cd /srv/shiny-server
  - sudo chown -R ${user_name}:shiny-apps .
  - sudo chmod g+w .
  - sudo chmod g+s .
  - git config --global user.email "${github_email}"
  - git config --global user.name "${github_username}"
  - cd /srv/shiny-server
  - git init
  - sudo R CMD javareconf
  - nginx -t
  - systemctl restart nginx

final_message: "The system is finally up, and the RStudio server is running on port 8787!"
