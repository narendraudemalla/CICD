name: Validate to QA Sandbox
run-name: ${{ github.actor }} is running the Github Actions 🚀

on:
  pull_request:
    types: [opened, edited, reopened, synchronize]
    branches:
      - qa
    paths:
      - 'force-app/**'

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment: QA #Testing
    steps:
      - run: echo "This is my first Job"
        name: "First Job Message"
      - name: Checkout Code
        uses: actions/checkout@v4.1.7
        with:
          fetch-depth: 0
      ##- name: npm install
        ##run: npm install
        ## Install Saleforce CLI
      - name: Install Salesforce CLI
        run: npm install @salesforce/cli --global   
      - name: Decrypt the server.key.enc file
        run: openssl enc -nosalt -aes-256-cbc -d -in ${{ secrets.ENCRYPTED_KEY_FILE }} -out ${{ secrets.JWT_KEY_FILE }} -base64 -K ${{ secrets.KEY }} -iv ${{ secrets.IV }}
      - name: Authorize with Salesforce org
        run: sf org login jwt --username ${{ secrets.SF_USERNAME }} --jwt-key-file ${{ secrets.JWT_KEY_FILE }} --client-id ${{ secrets.SF_CLIENT_ID }} --set-default --alias QA --instance-url ${{ secrets.SF_INSTANCE_URL }}
      
      - name: Validate The Code to QA Sandbox
        run: sf project deploy validate --source-dir force-app --target-org QA

      #- name: Deploy The Code to QA Sandbox
      #  run: sf project deploy start --source-dir force-app --target-org developer
      
  clean-up:
    runs-on: ubuntu-latest
    needs: [build-and-deploy]
    steps:
      - run: echo "This is my second Job"
        name: "Print Message"