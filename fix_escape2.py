with open('devbox', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the broken escape_html function
old = '''.replace('"', """)
        .replace("'", "'")'''

new = '''.replace('"', """)
        .replace("'", "'")'''

content = content.replace(old, new)

with open('devbox', 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed escape_html function')