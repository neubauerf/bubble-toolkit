#!/usr/bin/python

# Retrieve the api and secret key from the Cosmic installation

import urllib2
import sys
import json
import os.path
import getopt


class GetApiKeys:

    def __init__(self, argv):
        self.target = None
        self.username = None
        self.account = None
        self.handle_arguments(argv)

    # Handle the arguments
    def handle_arguments(self, argv):
        # Usage message
        help = "Usage: ./" + os.path.basename(__file__) + " [options]" + \
            "\n\t--target\t-t \t\tManagement Server host (default 'cs1')" + \
            "\n\t--username\t-u \t\tUser name (default 'admin')" + \
            "\n\t--account\t-a \t\tAccount (default 'admin')"

        try:
            opts, args = getopt.getopt(
                argv, "ht:u:a:", ["target=", "username=", "account="])
        except getopt.GetoptError as e:
            print "Error: " + str(e)
            print help
            sys.exit(2)

        for opt, arg in opts:
            if opt == "-h":
                print help
                sys.exit()
            elif opt in ("-t", "--target"):
                self.target = arg
            elif opt in ("-u", "--username"):
                self.username = arg
            elif opt in ("-a", "--account"):
                self.account = arg

        if self.target is None:
            self.target = "cs1"
        if self.username is None:
            self.username = "admin"
        if self.account is None:
            self.account = "admin"

    def send_api_cmd(self, cmd):
        url = "http://" + self.target + ":8096/client/api?command=%s" % cmd
        try:
            response = urllib2.urlopen(url)
            return response.read()
        except Exception as e:
            print "Problem connecting to %s" % url
            raise e

    def get_keys(self):
        userid=None
        apikey=None
        secretkey=None
        raw_details = self.send_api_cmd("listUsers&response=json&username=%s&account=%s" % (self.username, self.account))
        if raw_details:
            details = json.loads(raw_details)['listusersresponse']['user'][0]
            userid = details['id']
            if 'apikey' in details and 'secretkey' in details:
                apikey = details['apikey']
                secretkey = details['secretkey']

            if not apikey or not secretkey:
                details = json.loads(self.send_api_cmd(("registerUserKeys&response=json&id=%s" % userid)))
                apikey = details['registeruserkeysresponse']['userkeys']['apikey']
                secretkey = details['registeruserkeysresponse']['userkeys']['secretkey']

        return apikey, secretkey

    def get_endpoint(self):
        return "http://%s:8080/client/api" % self.target

    def get_networkacllists(self):
        raw_details = self.send_api_cmd("listNetworkACLLists&response=json")
        if raw_details:
            details = json.loads(raw_details)['listnetworkacllistsresponse']['networkacllist']
            for acl in details:
                if acl['name'] == 'default_allow':
                    default_allow = acl['id']
                if acl['name'] == 'default_deny':
                    default_deny = acl['id']

        return default_allow, default_deny

g = GetApiKeys(sys.argv[1:])

api_key, secret_key = g.get_keys()
endpoint = g.get_endpoint()
default_allow, default_deny = g.get_networkacllists()

print "export CLOUDSTACK_API_KEY=%s" % api_key
print "export TF_VAR_CLOUDSTACK_API_KEY=%s" % api_key

print "export CLOUDSTACK_SECRET_KEY=%s" % secret_key
print "export TF_VAR_CLOUDSTACK_SECRET_KEY=%s" % secret_key

print "export CLOUDSTACK_API_URL=%s" % endpoint
print "export TF_VAR_CLOUDSTACK_API_URL=%s" % endpoint

print "export TF_VAR_default_allow_acl_id=%s" % default_allow
print "export TF_VAR_default_deny_acl_id=%s" % default_deny

# To set variables in shell, use: source <(get_terraform_vars.py)
