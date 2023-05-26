#!/usr/bin/python

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: xdg-mime

short_description: This is a module to setup xdg mime info

version_added: "1.0.0"

description: This is a module to setup default application for mime types

options:
    application:
        description: This is the application to use for the mimetype by default
        required: true
        type: str
    mimetype:
        description: This is the mimetype to associate with the application
        required: true
        type: str

author:
    - Thomas Langé (@Lqp1)
'''

EXAMPLES = r'''
- name: Test with a message
  xdg-mime:
    application: thunar.desktop
    mimetype: inode/directory
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule
import subprocess


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        application=dict(type='str', required=True),
        mimetype=dict(type='str', required=True)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    result = dict(
        changed=False,
        original_state='',
        new_state=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    current = subprocess.run(['xdg-mime', 'query', 'default', module.params['mimetype']], capture_output=True, text=True)
    if current.returncode != 0:
        module.fail_json(msg=f"xdg-mime binary call failed with {current.stderr}", **result)

    result['original_state'] = str(current.stdout).strip()


    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    if result['original_state'] != module.params['application']:
        call = subprocess.run(['xdg-mime', 'default', module.params['application'], module.params['mimetype']])
        if call.returncode != 0:
            module.fail_json(msg=f"xdg-mime binary call failed with {current.stderr}", **result)
        result['changed'] = True

    result['new_state'] = module.params['application']

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()

