#!/bin/bash
set -e

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

echo -e "${GREEN}🚀 Step 1: Terraform Apply...${NC}"
cd terraform
terraform init -input=false
terraform apply -auto-approve

echo -e "${GREEN}✅ Terraform apply completed!${NC}"

# Go back to root
cd ..

echo -e "${GREEN}🚀 Step 2: Activate Python Virtualenv...${NC}"
if [ ! -d "venv" ]; then
    echo -e "${RED}❌ Virtualenv not found. Please run: python3 -m venv venv && source venv/bin/activate && pip install -r ansible/requirements.txt${NC}"
    exit 1
fi

source venv/bin/activate

echo -e "${GREEN}✅ Virtualenv activated!${NC}"

echo -e "${GREEN}🚀 Step 3: Configure Monitoring Server...${NC}"
cd ansible
ansible-playbook playbooks/setup_monitoring.yml

echo -e "${GREEN}✅ Monitoring Server setup completed!${NC}"

echo -e "${GREEN}🚀 Step 4: Configure Application Clients...${NC}"
ansible-playbook playbooks/setup_clients.yml

echo -e "${GREEN}✅ Clients setup completed!${NC}"

echo -e "${GREEN}🎉 Deployment Finished!${NC}"

