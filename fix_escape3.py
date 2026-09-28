with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the broken escape_html function - match the exact bytes
old = '''.replace('"', """)
        .replace("'", "'")'''

new = '''.replace('"', """)
        .replace("'", "'")'''

# The actual content has escaped backslashes
old_actual = '.replace(\'"\', """)\n        .replace("\\\'", "\'")'
new_actual = '.replace(\'"\', """")\n        .replace("\\\'", "\'")'

content = content.replace(old_actual, new_actual)

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed escape_html function')