#!/usr/bin/python2

# Determines the number of unread emails in the specified maildir

import os

maildir='~/Mail'

# Make the maildir path useable
maildir = os.path.expandvars(os.path.expanduser(maildir))

# Get a list of all mailboxes in the maildir
mailboxes = os.listdir(maildir)

# Get the sum of the number of new messages in the mailboxes
new_count = reduce(lambda total, mailbox: total + len(os.listdir(maildir+'/'+mailbox+'/Inbox/new')), mailboxes, 0)

print new_count
