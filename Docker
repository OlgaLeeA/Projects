# Use an official Python base image
FROM python:3.9-slim-buster

# Update the system and install required dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ssh \
        openssh-client \
        git \
        rsync \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible and any other necessary Python packages
RUN pip install --upgrade pip && \
    pip install ansible

# Set up SSH key
ARG SSH_PRIVATE_KEY
RUN mkdir -p /root/.ssh && \
    echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    ssh-keyscan -t rsa,dsa,ecdsa -H 178.128.83.86 >> /root/.ssh/known_hosts

# Create a working directory
RUN mkdir -p /ansible
WORKDIR /ansible

# Copy your Ansible playbook and inventory files
COPY task8.yml /ansible/task8.yml
COPY inventory.ini /ansible/inventory.ini

# Run the Ansible playbook
CMD ["ansible-playbook", "-i", "inventory.ini", "task8.yml"]

