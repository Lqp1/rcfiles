#!/usr/bin/python

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: erepository

short_description: This is a module to setup gentoo repositories

version_added: "1.0.0"

description: This is a module to setup enabled repositories on a gentoo machine

options:
    name:
        description: The name of the repository
        required: true
        type: str
    state:
        description: whether the rpeository should be enabled or not
        required: false
        type: str

author:
    - Thomas Langé (@Lqp1)
'''

EXAMPLES = r'''
- name: Enable guru
  erepository:
    name: guru
    state: present
'''

RETURN = r'''
'''

from ansible.module_utils.basic import AnsibleModule
import subprocess
import re

def call(name: str, action:str):
    out = subprocess.run(['eselect', 'repository', action, name], capture_output=True, text=True)
    if current.returncode != 0:
        module.fail_json(msg=f"eselect repository call failed with {current.stderr}", **result)

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        state=dict(type='str', required=False, default='present')
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    result = dict(
        changed=False,
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
    )

    current = subprocess.run(['eselect', 'repository', 'list', '-i'], capture_output=True, text=True)
    if current.returncode != 0:
        module.fail_json(msg=f"eselect repository call failed with {current.stderr}", **result)
    repositories = current.stdout.split('\n')[1:]
    repositories = filter(lambda x:len(x) > 0, repositories)
    repositories = list(map(lambda x:re.search(r'] (.*?) .*$', x).group(1), repositories))

    present = module.params['name'] in repositories


    if module.params['state'] == 'present':
        if not present:
            call(module.params['name'], 'enable')
            result['changed'] = True
    elif module.params['state'] == 'absent':
        if present:
            call(module.params['name'], 'disable')
            result['changed'] = True
    else:
        module.fail_json(msg=f"{module.params['state']} is not supported", **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()

