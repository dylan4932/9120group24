def valid_user(username, password):
    return username.isalnum()

print(valid_user('dylan4932', '000'))
print(valid_user('ChrisP', ''))
print(valid_user('-', '000'))