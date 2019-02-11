import logging
import json
import boto3

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError


# logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


# AWS
ssm = boto3.client('ssm')


def get_secret(key):
    """
    Retrieve AWS SSM Parameter (decrypted if necessary)
    Ex: get_secret('/path/to/service/myParam')
    """
    response = ssm.get_parameter(Name=key, WithDecryption=True)
    return response['Parameter']['Value']


def post_to_slack(message):
    """
    Ex: post_to_slack({'text': 'Unknown command :cry:'})
    """
    hook_url = get_secret('SlackAlertsHookURL')
    request = Request(hook_url, json.dumps(message).encode('utf-8'))
    try:
        response = urlopen(request)
        response.read()
        logger.info('Response posted to Slack channel')
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)


def handler(event, context):
    """
    Process CloudWatch Requests
    Thanks to https://serverless.com/blog/serverless-cloudtrail-cloudwatch-events/
    Full list of CloudWatch events: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/EventTypes.html
    """

    # Skip scheduled events (they are just warming up the function)
    if 'detail-type' in event and event['detail-type'] == 'Scheduled Event':
        logger.info('Scheduled Event ignored')
        return

    account = event.get('account')
    event_type = event.get('detail-type')

    if event.get('source') == 'aws.autoscaling':
        asg = event.get('detail').get('AutoScalingGroupName')
        instance = event.get('detail').get('EC2InstanceId')
        post_to_slack({
            "text": event_type,
            "icon_emoji": ":rotating_light:",
            "attachments": [
                {
                    "text": 'Instance *%s* has changed state in the Auto Scaling Group *%s* (account *%s*)' % (instance, asg, account),
                    "color": "#ff0000"
                }
            ]
        })
    elif event.get('source') == 'aws.ec2':
        instance = event.get('detail').get('instance-id')
        state = event.get('detail').get('state')
        post_to_slack({
            "text": event_type,
            "icon_emoji": ":rotating_light:",
            "attachments": [
                {
                    "text": 'Instance *%s* has changed state to *%s* in account *%s*' % (instance, state, account),
                    "color": "#ff0000"
                }
            ]
        })
    elif event.get('source') == 'aws.ssm':
        name = event.get('detail').get('name')
        operation = event.get('detail').get('operation')
        post_to_slack({
            "text": event_type,
            "icon_emoji": ":rotating_light:",
            "attachments": [
                {
                    "text": 'A *%s* operation was performed on parameter *%s* in account *%s*' % (operation, name, account),
                    "color": "#ff0000"
                }
            ]
        })
    elif event.get('source') == 'aws.signin':
        sourceIPAddress = event.get('detail').get('sourceIPAddress')
        post_to_slack({
            "text": event_type,
            "icon_emoji": ":rotating_light:",
            "attachments": [
                {
                    "text": 'Detected from IP address *%s* in account *%s*' % (sourceIPAddress, account),
                    "color": "#ff0000"
                }
            ]
        })
    else:
        logger.warn('Event ignored')
