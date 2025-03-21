'''
Follow these steps to configure the webhook in Slack:
  1. Navigate to https://<your-team-domain>.slack.com/services/new
  2. Search for and select "Incoming WebHooks".
  3. Choose the default channel where messages will be sent and click "Add Incoming WebHooks Integration".
  4. Copy the webhook URL from the setup instructions and use it in the next section.

To encrypt your secrets use the following steps:
  1. Create or use an existing KMS Key - http://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html
  2. Expand "Encryption configuration" and click the "Enable helpers for encryption in transit" checkbox
  3. Paste <SLACK_CHANNEL> into the slackChannel environment variable
     Note: The Slack channel does not contain private info, so do NOT click encrypt
  4. Paste <SLACK_HOOK_URL> into the kmsEncryptedHookUrl environment variable and click "Encrypt"
     Note: You must exclude the protocol from the URL (e.g. "hooks.slack.com/services/abc123").
  5. Give your function's role permission for the `kms:Decrypt` action using the provided policy template
'''

import boto3
import json
import logging
import os

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# The base-64 encoded, encrypted key (CiphertextBlob) stored in the kmsEncryptedHookUrl environment variable
ENCRYPTED_HOOK_URL = os.environ['kmsEncryptedHookUrl']
# The Slack channel to send a message to stored in the slackChannel environment variable
ENCRYPTED_SLACK_CHANNEL = os.environ['slackChannel']

HOOK_URL = boto3.client('kms').decrypt(
    CiphertextBlob=b64decode(ENCRYPTED_HOOK_URL)
)['Plaintext'].decode('utf-8')

SLACK_CHANNEL = boto3.client('kms').decrypt(
    CiphertextBlob=b64decode(ENCRYPTED_SLACK_CHANNEL)
)['Plaintext'].decode('utf-8')

def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    logger.info("Event type: " + str(type(event)))
    message = event['Records'][0]['Sns']['Message']
    logger.info("Message: " + str(message))

    #alarm_name = message['AlarmName']
    alarm_name = 'Budget-Overage'
    #old_state = message['OldStateValue']
    #new_state = message['NewStateValue']
    new_state = 'Alert'
    #reason = message['NewStateReason']
    reason = 'Alert Received'

    slack_message = {
        'channel': SLACK_CHANNEL,
        'text': "%s state is now %s: %s\nmessage: %s" % (alarm_name, new_state, reason, message)
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)

